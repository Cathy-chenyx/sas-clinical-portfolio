/******************************************************************************
** 程序名称: data_quality_check.sas
** 程序描述: 数据质量检查宏 - 用于临床试验数据清理
** 作者: Chen Yuxuan
** 创建日期: 2024年
** 修改历史:
**   2024-XX-XX: 初始版本 - 实现缺失值检查功能
**   2024-XX-XX: 添加异常值检测功能
**
** 功能说明:
**   本宏用于批量检查数据集中的数据质量问题，包括:
**   1. 缺失值检查
**   2. 异常值检测（基于IQR方法）
**   3. 逻辑一致性验证
**   4. 生成数据质量报告
**
** 输入参数:
**   dsn       - 输入数据集名称（必需）
**   varlist   - 需要检查的变量列表，空格分隔（必需）
**   outreport - 输出报告数据集名称（可选，默认=work.dq_report）
**   idvar     - 标识变量（可选，用于定位问题记录）
**
** 输出:
**   1. 日志中输出检查结果摘要
**   2. 输出数据集中包含详细检查结果
**
** 示例:
**   %data_quality_check(
**       dsn=work.dm,
**       varlist=age gender race,
**       outreport=work.dm_quality,
**       idvar=usubjid
**   );
******************************************************************************/

%MACRO data_quality_check(
    dsn=,           /* 输入数据集 */
    varlist=,       /* 变量列表 */
    outreport=work.dq_report,  /* 输出报告 */
    idvar=          /* 标识变量 */
);

    *==================================================;
    * 参数验证
    *==================================================;
    
    %IF &dsn= %THEN %DO;
        %PUT ERROR: 必须指定输入数据集 (dsn=);
        %RETURN;
    %END;
    
    %IF &varlist= %THEN %DO;
        %PUT ERROR: 必须指定变量列表 (varlist=);
        %RETURN;
    %END;
    
    %PUT ==========================================;
    %PUT 数据质量检查开始;
    %PUT 数据集: &dsn;
    %PUT 检查变量: &varlist;
    %PUT 时间: %SYSFUNC(putn(%SYSFUNC(datetime()), datetime20.));
    %PUT ==========================================;
    
    *==================================================;
    * 第一部分: 缺失值检查
    *==================================================;
    
    %PUT ;
    %PUT ----- 缺失值检查 -----;
    
    %LET n_vars = %SYSFUNC(countw(&varlist));
    
    * 创建临时数据集存储结果 ;
    DATA _dq_missing;
        LENGTH variable $32 check_type $20;
        check_type = "缺失值";
    RUN;
    
    %DO i = 1 %TO &n_vars;
        %LET var = %SCAN(&varlist, &i);
        
        PROC SQL NOPRINT;
            SELECT 
                COUNT(*) INTO :total_obs
            FROM &dsn;
            
            SELECT 
                COUNT(*) INTO :n_miss
            FROM &dsn
            WHERE &var IS MISSING;
        QUIT;
        
        %LET pct_miss = %SYSEVALF(&n_miss / &total_obs * 100);
        
        %PUT 变量 &var:;
        %PUT   总观测数: &total_obs;
        %PUT   缺失值数: &n_miss;
        %PUT   缺失比例: %SYSFUNC(round(&pct_miss, 0.01))%;
        
        * 追加到结果数据集 ;
        PROC SQL;
            INSERT INTO _dq_missing
            SET variable = "&var",
                total_obs = &total_obs,
                missing_count = &n_miss,
                missing_pct = %SYSFUNC(round(&pct_miss, 0.01));
        QUIT;
    %END;
    
    *==================================================;
    * 第二部分: 异常值检测（数值变量）
    *==================================================;
    
    %PUT ;
    %PUT ----- 异常值检测（基于IQR方法） -----;
    
    DATA _dq_outliers;
        LENGTH variable $32 check_type $20;
        check_type = "异常值";
    RUN;
    
    %DO i = 1 %TO &n_vars;
        %LET var = %SCAN(&varlist, &i);
        
        * 检查变量类型 ;
        PROC SQL NOPRINT;
            SELECT type INTO :vartype
            FROM SASHELP.vcolumn
            WHERE libname='WORK' AND 
                  memname=UPCASE("&dsn") AND 
                  name=UPCASE("&var");
        QUIT;
        
        %IF &vartype = num %THEN %DO;
            * 计算 IQR ;
            PROC SQL NOPRINT;
                SELECT 
                    Q1, Q3, IQR,
                    Q1 - 1.5*IQR AS lower_bound,
                    Q3 + 1.5*IQR AS upper_bound
                INTO :q1, :q3, :iqr, :lower, :upper
                FROM (
                    SELECT 
                        P25 AS Q1,
                        P75 AS Q3,
                        P75 - P25 AS IQR
                    FROM (
                        SELECT 
                            PCTL(25, &var) AS P25,
                            PCTL(75, &var) AS P75
                        FROM &dsn
                        WHERE &var IS NOT MISSING
                    )
                );
            QUIT;
            
            * 统计异常值 ;
            PROC SQL NOPRINT;
                SELECT COUNT(*) INTO :n_outliers
                FROM &dsn
                WHERE &var < &lower OR &var > &upper;
            QUIT;
            
            %PUT 变量 &var (数值型):;
            %PUT   正常范围: %SYSFUNC(round(&lower, 0.01)) - %SYSFUNC(round(&upper, 0.01));
            %PUT   异常值数: &n_outliers;
            
            * 追加到结果 ;
            PROC SQL;
                INSERT INTO _dq_outliers
                SET variable = "&var",
                    lower_bound = %SYSFUNC(round(&lower, 0.01)),
                    upper_bound = %SYSFUNC(round(&upper, 0.01)),
                    outlier_count = &n_outliers;
            QUIT;
        %END;
        %ELSE %DO;
            %PUT 变量 &var (字符型): 跳过异常值检测;
        %END;
    %END;
    
    *==================================================;
    * 第三部分: 生成综合报告
    *==================================================;
    
    %PUT ;
    %PUT ----- 生成综合报告 -----;
    
    DATA &outreport;
        SET _dq_missing _dq_outliers;
        check_date = DATETIME();
        FORMAT check_date datetime20.;
    RUN;
    
    * 输出报告摘要 ;
    PROC PRINT DATA=&outreport NOOBS;
        TITLE "数据质量检查报告 - &dsn";
    RUN;
    
    *==================================================;
    * 清理临时数据集
    *==================================================;
    
    PROC DATASETS LIB=work NOLIST;
        DELETE _dq_missing _dq_outliers;
    QUIT;
    
    %PUT ;
    %PUT ==========================================;
    %PUT 数据质量检查完成;
    %PUT 详细报告保存在: &outreport;
    %PUT ==========================================;

%MEND data_quality_check;


*==================================================;
* 宏使用示例
*==================================================;

/*
示例1: 基本使用
%data_quality_check(
    dsn=work.dm,
    varlist=age gender race
);

示例2: 完整参数
%data_quality_check(
    dsn=sdtm.dm,
    varlist=age gender race weight height,
    outreport=work.dm_qc_report,
    idvar=usubjid
);

示例3: 在ACS项目中的应用
%data_quality_check(
    dsn=acs.analysis_data,
    varlist=HsCRP BUN CystatinC NTproBNP Uric_acid WBC Age Gender,
    outreport=work.acs_qc_report
);
*/
