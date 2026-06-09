# SAS 临床数据作品集

> 准备 CTA-Digital 岗位的 SAS 宏编程与 CDISC 标准化学习项目

**作者**: Chen Yixin 
**GitHub**: [Cathy-chenyx](https://github.com/Cathy-chenyx)  
**学习目标**: 掌握 SAS 宏编程和 CDISC 标准，胜任临床试验数据管理工作

---

## 📊 项目概览

本仓库记录了我系统学习 SAS 宏编程和 CDISC 临床数据标准的过程，包含从基础语法到项目实战的完整代码和学习笔记。

### 背景
- 拥有 R 语言临床数据分析经验（ACS 项目）
- 正在向 SAS 宏编程和 CDISC 标准转型
- 为 CTA-Digital（FSP）岗位做准备

---

## 🎯 学习目标

- [x] 掌握 SAS 宏编程核心概念（%LET, %MACRO, %DO, %IF）
- [ ] 理解 CDISC SDTM/ADaM 数据标准
- [ ] 能够独立编写数据质量检查宏
- [ ] 能够创建标准化的 SDTM 域
- [ ] 能够完成完整的临床数据分析流程

---

## 📁 仓库结构

```
sas-clinical-portfolio/
├── 00_setup/                    # 环境配置
│   └── sas_studio_config.sas    # SAS Studio 配置
│
├── 01_macro_basics/             # 宏编程基础练习
│   ├── day01_variables.sas      # 宏变量练习
│   ├── day02_loops.sas          # 循环练习
│   └── README.md                # 阶段总结
│
├── 02_cdisc_foundation/         # CDISC标准学习
│   ├── sdtm/                    # SDTM练习
│   │   ├── dm_domain.sas        # 人口学域
│   │   └── ae_domain.sas        # 不良事件域
│   ├── adam/                    # ADaM练习
│   └── metadata/                # 元数据文件
│
├── 03_projects/                 # 项目实战
│   ├── acs_baseline_analysis/   # ACS基线分析（SAS版）
│   │   ├── README.md
│   │   ├── 01_data_prep.sas
│   │   └── 02_baseline_macro.sas
│   └── data_quality_toolkit/    # 数据质量工具
│       ├── README.md
│       └── data_quality_check.sas
│
├── 04_utilities/                # 工具宏库
│   └── macros/                  # 可复用宏
│       ├── make_empty_dataset.sas
│       ├── dtc2dt.sas
│       └── data_quality.sas
│
├── 05_notes/                    # 学习笔记
│   ├── macro_syntax_cheatsheet.md
│   ├── cdisc_domain_guide.md
│   └── interview_preparation.md
│
└── data/                        # 示例数据
```

---

## 💻 技术栈

- **SAS**: 宏编程、PROC SQL、DATA Step、ODS
- **CDISC**: SDTM IG、ADaM IG、Define.xml
- **工具**: SAS Studio (SAS OnDemand for Academics)
- **其他**: R (数据分析基础)

---

## 🚀 主要项目

### 1. 宏编程基础练习
从 %LET 到复杂宏的渐进式学习。

**关键技能**:
- 宏变量定义与引用 (%LET, &)
- 宏程序结构 (%MACRO / %MEND)
- 条件判断 (%IF-%THEN-%ELSE)
- 循环控制 (%DO-%TO-%END)

[查看代码](./01_macro_basics/)

### 2. CDISC 域创建
使用示例数据创建符合 SDTM 标准的 DM、AE 域。

**学习内容**:
- SDTM 数据结构理解
- DM（人口统计学）域创建
- AE（不良事件）域创建
- 元数据驱动编程

[查看代码](./02_cdisc_foundation/)

### 3. ACS 基线分析（SAS版）
将原有 R 分析流程改写为 SAS 宏自动化。

**项目背景**:
- 基于 ACS 临床数据（急性冠脉综合征）
- 6个应激指标的基线特征分析
- 批量统计检验和报告生成

[查看代码](./03_projects/acs_baseline_analysis/)

### 4. 数据质量检查工具
编写可复用的数据验证宏，用于临床试验数据清理。

**功能**:
- 缺失值批量检查
- 异常值检测
- 逻辑一致性验证
- 自动生成质量报告

[查看代码](./03_projects/data_quality_toolkit/)

---

## 📈 学习进度

| 阶段 | 内容 | 状态 | 日期 |
|------|------|------|------|
| 01 | 宏编程基础 | 🔄 进行中 | Day 1-2 |
| 02 | CDISC标准 | ⏳ 待开始 | Day 3-4 |
| 03 | 项目实战 | ⏳ 待开始 | Day 5-6 |
| 04 | 面试准备 | ⏳ 待开始 | Day 7 |

---

## 📚 学习资源

### 官方文档
- [SAS Macro Language Reference](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/mcrolref/titlepage.htm)
- [CDISC SDTM Implementation Guide](https://www.cdisc.org/standards/foundational/sdtm)
- [CDISC ADaM Implementation Guide](https://www.cdisc.org/standards/foundational/adam)

### 书籍
- 《Implementing CDISC Using SAS》 - SAS官方教材
- 《Carpenter's Complete Guide to the SAS Macro Language》

### 社区
- [PhUSE](https://phuse.global/) - 制药SAS用户组
- [SAS Communities](https://communities.sas.com/)

---

## 🔗 相关项目

- [ACS_Analysis_Project](https://github.com/Cathy-chenyx/ACS_Analysis_Project)
  - 原始 R 语言临床数据分析项目
  - 包含完整的 ACS 患者数据分析流程
  - 本项目中的 ACS 基线分析 SAS 版基于此项目数据

---

## 📝 学习笔记

### 宏编程核心概念

```sas
/* 宏变量 - 文本替换 */
%LET indicator = HsCRP;
%PUT &indicator;  /* 输出: HsCRP */

/* 宏程序 - 代码生成器 */
%MACRO analyze_var(var=);
    PROC MEANS DATA=work.data;
        VAR &var;
    RUN;
%MEND analyze_var;

/* 调用宏 */
%analyze_var(var=HsCRP);
```

### CDISC SDTM 核心域

| 域代码 | 名称 | 描述 |
|--------|------|------|
| DM | Demographics | 人口统计学信息 |
| AE | Adverse Events | 不良事件 |
| LB | Laboratory | 实验室检查结果 |
| VS | Vital Signs | 生命体征 |
| CM | Concomitant Medications | 合并用药 |

---

## 📧 联系方式

- **GitHub**: [Cathy-chenyx](https://github.com/Cathy-chenyx)
- **邮箱**: 3227042017@i.smu.edu.cn
- **LinkedIn**: [www.linkedin.com/in/yixin-chen-1a809b36a]

