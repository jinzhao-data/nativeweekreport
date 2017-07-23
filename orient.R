




library(RODBC)
library(dplyr)
library(openxlsx)
library(ggplot2)
library(plotly)
options(scipen=200)
options(digits=2)
channel <- odbcConnect("native", uid = "native_data_pm_r", pwd = "nativeads_data_PW4Read",DBMSencoding="GBK")
orient <- sqlQuery(channel,
              " select A.stdate,sum(A.c1)  as 人群定向消费,sum(B.c2) 定向人群的非定向消费,sum(A.cl1),sum(A.s1),sum(B.cl2),sum(B.s2)
                from 
                (SELECT stdate,user_id,sum(charge) as c1,sum(clicks) as cl1, sum(shows) as s1
                FROM native_report_fc_adver
                WHERE
                stdate BETWEEN 20170712 AND 20170720
                AND orient LIKE '%人群定向%' group by stdate,user_id) as A
                left join
                (SELECT  stdate,user_id,sum(charge) as c2,sum(clicks) as cl2,sum(shows) as s2
                FROM
                native_report_fc_adver
                WHERE
                stdate BETWEEN 20170712 AND 20170720
                AND orient not LIKE '%人群定向%' group by stdate,user_id ) as B
                on A.stdate = B.stdate and A.user_id = B.user_id
                group by A.stdate;")
View(orient)