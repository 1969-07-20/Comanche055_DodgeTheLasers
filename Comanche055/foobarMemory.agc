FB_N            EQUALS   CSMPOS        #  Value for which to compute 'Dodge the Lasers' solution

FB_Q0           EQUALS   FB_N +1       #  Location to save Q for call to main routine
FB_Q1           EQUALS   FB_Q0 +1      #  Location to save Q for call to level1 subroutine

FB_NUMBP        EQUALS   FB_Q1 +1      #  Number of entries in each table below

FB_N00          EQUALS   FB_NUMBP +1   #  Table to hold the locations of breakpoints
FB_V00          EQUALS   FB_N00 +6     #  Table to hold the values of breakpoints
FB_S00          EQUALS   FB_V00 +6     #  Table to hold the cumulative sums at breakpoint locations

FB_TMP0         EQUALS   FB_S00 +6     #  Work area
FB_TMP1         EQUALS   FB_TMP0 +1
FB_TMP2         EQUALS   FB_TMP1 +1
FB_TMP3         EQUALS   FB_TMP2 +1
FB_TMP4         EQUALS   FB_TMP3 +1
FB_TMP5         EQUALS   FB_TMP4 +1
FB_TMP6         EQUALS   FB_TMP5 +1
FB_TMP7         EQUALS   FB_TMP6 +1
