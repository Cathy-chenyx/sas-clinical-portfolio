/******************************************************************************
** 程序名称: day01_variables.sas
** 程序描述: SAS 宏变量基础练习 - Day 1
** 作者: Chen Yixin
** 创建日期: 2024年
** 学习目标:
**   - 理解宏变量的概念
**   - 掌握 %LET 和 & 的使用
**   - 学习宏变量的三种创建方式
******************************************************************************/

*==================================================;
* 第一部分: 宏变量基础
*==================================================;

* 1.1 使用 %LET 创建宏变量 ;
%LET project_name = ACS_Analysis;
%LET n_indicators = 6;
%LET indicator_list = HsCRP BUN CystatinC NTproBNP Uric_acid WBC;

* 查看宏变量的值 ;
%PUT ==========================================;
%PUT 项目名称: &project_name;
%PUT 指标数量: &n_indicators;
%PUT 指标列表: &indicator_list;
%PUT ==========================================;

* 1.2 在代码中引用宏变量 ;
DATA test_data;
    LENGTH indicator $20;
    indicator = "&project_name";
    n_vars = &n_indicators;
    OUTPUT;
RUN;

PROC PRINT DATA=test_data;
    TITLE "测试宏变量引用";
RUN;

*==================================================;
* 第二部分: 宏变量的三种创建方式
*==================================================;

* 方式1: %LET (最常用) ;
%LET method1 = "使用%LET创建";
%PUT 方式1: &method1;

* 方式2: CALL SYMPUTX (在DATA步中动态创建) ;
DATA _null_;
    today = TODAY();
    CALL SYMPUTX("current_date", PUT(today, YYMMDD10.));
    CALL SYMPUTX("n_obs", 100);
RUN;

%PUT 当前日期: &current_date;
%PUT 观测数量: &n_obs;

* 方式3: PROC SQL INTO (从查询结果创建) ;
PROC SQL NOPRINT;
    SELECT COUNT(*) INTO :n_total
    FROM SASHELP.CLASS;
    
    SELECT AVG(age) INTO :avg_age
    FROM SASHELP.CLASS;
QUIT;

%PUT 总人数: &n_total;
%PUT 平均年龄: &avg_age;

*==================================================;
* 第三部分: 宏变量在循环中的应用
*==================================================;

* 使用 %SCAN 遍历列表 ;
%LET indicators = HsCRP BUN CystatinC;
%LET n = %SYSFUNC(countw(&indicators));

%PUT ==========================================;
%PUT 遍历指标列表:;

%DO i = 1 %TO &n;
    %LET var = %SCAN(&indicators, &i);
    %PUT 第&i个指标: &var;
%END;

%PUT ==========================================;

*==================================================;
* 第四部分: 练习任务
*==================================================;

/*
练习1: 创建你自己的宏变量
- 创建一个包含你项目信息的宏变量
- 使用 %PUT 打印查看

练习2: 动态创建宏变量
- 使用 DATA _null_ 和 CALL SYMPUTX 创建宏变量
- 尝试从数据集中计算统计量并存入宏变量

练习3: 遍历变量列表
- 创建一个包含5个变量名的列表
- 使用 %DO 循环和 %SCAN 遍历并打印每个变量
*/

* 练习参考答案示例:;
%LET my_project = CTA_Digital_Prep;
%LET target_company = Pfizer;

%PUT 我的项目: &my_project;
%PUT 目标公司: &target_company;

*==================================================;
* 学习总结
*==================================================;

/*
今日学习要点:
1. 宏变量是文本替换工具，不是数据集中的变量
2. %LET 用于直接赋值，&用于引用
3. CALL SYMPUTX 用于在DATA步中动态创建宏变量
4. PROC SQL INTO 用于从查询结果创建宏变量
5. %SCAN 和 %COUNTW 用于处理列表

面试可能问到的问题:
Q: 宏变量和DATA步变量有什么区别?
A: 宏变量是文本替换，在编译前处理；DATA步变量是数据，在运行时处理。

Q: 如何在DATA步中创建宏变量?
A: 使用 CALL SYMPUTX 例程。
*/
