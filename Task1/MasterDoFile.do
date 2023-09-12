global rootdir "G:\我的云端硬盘"
cd $rootdir

* Build datasets for analysis
!rmdir "Yifan_Yang\Task1\Build\output" /s /q
mkdir "Yifan_Yang\Task1\Build\output"
!rmdir "Yifan_Yang\Task1\Analysis\input" /s /q
mkdir "Yifan_Yang\Task1\Analysis\input"

do "Yifan_Yang\Task1\Build\code\TableIV_data.do"
do "Yifan_Yang\Task1\Build\code\TableV_data.do"
do "Yifan_Yang\Task1\Build\code\TableVI_data.do"

* Analysis
!rmdir "Yifan_Yang\Task1\Analysis\outcome" /s /q
mkdir "Yifan_Yang\Task1\Analysis\outcome"

do "Yifan_Yang\Task1\Analysis\code\TableIV.do"
do "Yifan_Yang\Task1\Analysis\code\TableV.do"
do "Yifan_Yang\Task1\Analysis\code\TableVI.do"