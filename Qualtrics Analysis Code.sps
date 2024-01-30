* Encoding: UTF-8.
*Set directory to location of where you have downloaded and unzipped data. Download as SPSS sav dataset My path below will be different from yours.
cd "Z:\jrg363\Workshops Sp24\Qualtrics".


GET
  FILE='Z:\jrg363\Workshops Sp24\Qualtrics\Sample Survey_January 30, 2024_12.58.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

*First click is the time it took to get past the first question. 



*If clicked within 10 seconds.
DATASET ACTIVATE DataSet1.
IF  (Q3_Page_Submit <= 10) In_Ten=1.
EXECUTE.

RECODE In_Ten (SYSMIS=0).
EXECUTE.

*Clean dataset.
alter type Q6 Q10 (f6.3).
EXECUTE.

*Split up datasets.
DATASET COPY  Right.
DATASET ACTIVATE  Right.
FILTER OFF.
USE ALL.
SELECT IF (Q4 = 1).
EXECUTE.
DATASET ACTIVATE  DataSet1.

DATASET COPY  Left.
DATASET ACTIVATE  Left.
FILTER OFF.
USE ALL.
SELECT IF (Q4 = 2).
EXECUTE.
DATASET ACTIVATE  DataSet1.

*basic summary stats. 

FREQUENCIES VARIABLES=In_Ten Q4
  /PIECHART PERCENT
  /ORDER=ANALYSIS.


DESCRIPTIVES VARIABLES=Q6 Q10 Q3_Page_Submit
  /STATISTICS=MEAN STDDEV MIN MAX.

*rename variables.
RENAME VARIABLES (Q7_1 = Meals) (Q8_1 = time) (Q8_2 = quality) (Q8_3 = budget) (Q9_1 = progf) (Q9_2 = Ith).
EXECUTE.

*value labels.

*frequencies by certain questions.

FREQUENCIES VARIABLES=progf Ith time quality budget Meals
  /PIECHART PERCENT
  /ORDER=ANALYSIS.

EXECUTE.

* Export Output.
OUTPUT EXPORT
  /CONTENTS  EXPORT=ALL  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /PDF  DOCUMENTFILE='Results.pdf'
     EMBEDBOOKMARKS=YES  EMBEDFONTS=YES.
EXECUTE.
