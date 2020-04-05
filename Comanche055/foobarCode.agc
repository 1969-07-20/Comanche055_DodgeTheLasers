
#  ============
#  Main routine
#  ============

#  Inputs:
#     A:     Value to compute the "Dodge the Lasers" solution for

#  Outputs:
#     A:     Answer to puzzle

FOOBAR          EXTEND              #  Save return address in FB_Q0
                QXCH    FB_Q0

                TS      FB_N        #  Save the argument
                TC      FB1_SUB     #  Call routine which computes breakpoints (FB1_SUB)

                CA      FB_N        #  Call FB2_SUB which calculates cumulative sum for desired location
                TC      FB2_SUB

                EXTEND              #  Restore the return address.
                QXCH    FB_Q0
                RETURN


#  ==============================
#  Routine to compute breakpoints
#  ==============================

#  Inputs:
#     FB_N:  Compute BP up to N

#  Outputs:
#     FB_NUMBP:  Number of breakpoints
#     FB_Nxx:    Table of locations of breakpoints
#     FB_Vxx:    Table of values of breakpoints
#     FB_Sxx:    Table of cumulative sums for breakpoints

FB1_P           EQUALS  FB_TMP0
FB1_Q           EQUALS  FB_TMP1

FB1_SUB         EXTEND              #  Save return address in FB_Q1
                QXCH    FB_Q1

                CA      S+ZERO      #  Initialize FB_NUMBP with 0
                TS      FB_NUMBP

                INCR    A           #  Initialize P and Q with 1
                TS      FB1_P
                TS      FB1_Q


#  Loop to calculate breakpoints less than or equal to value in FB_N

FB1_LOOP        CA      FB_NUMBP    #  Branch to correct logic if this is an even or odd iteration
                MASK    ONE
                EXTEND
                BZF     FB1_EVEN


#  Update breakpoint for the odd iteration case

FB1_ODD         CA      FB1_P       #  But first exit loop if reached the end
                                    #  (ending logic differs for even or odd iterations)
                EXTEND
                SU      FB_N
                EXTEND
                BZMF    FB1_LBL0
                TCF     FB1_FINI

FB1_LBL0        CA      FB1_P       #  Store breakpoint location
                INDEX   FB_NUMBP
                TS      FB_N00

                CA      FB1_Q       #  Store breakpoint value
                AD      A
                INDEX   FB_NUMBP
                TS      FB_V00

                TCF     FB1_LBL2    #  Branch to logic to calculate cumulative sum for this breakpoint


#  Update breakpoint for the even iteration case

FB1_EVEN        CA      FB1_Q       #  But first exit loop if reached the end
                                    #  (ending logic differs for even or odd iterations)
                EXTEND
                SU      FB_N
                EXTEND
                BZMF    FB1_LBL1
                TCF     FB1_FINI

FB1_LBL1        CA      FB1_Q       #  Store breakpoint location
                INDEX   FB_NUMBP
                TS      FB_N00

                CA      FB1_P       #  Store breakpoint value
                INDEX   FB_NUMBP
                TS      FB_V00


#  Calculate cumulative sums for this breakpoint

FB1_LBL2        INDEX   FB_NUMBP    #  Calculate cumulative sum up to breakpoint location - 1
                CA      FB_N00
                EXTEND
                DIM     A
                TC      FB2_SUB

                INDEX   FB_NUMBP    #  Add the breakpoint value at breakpoint location
                AD      FB_V00

                INDEX   FB_NUMBP    #  Store current cumulative sum
                TS      FB_S00

                INCR    FB_NUMBP    #  Done with this breakpoint, increment breakpoint count


#  Increment P and Q and repeat iteration

                CA      FB1_P       #  Update P and Q as follows:  P, Q = P + 2 * Q, P + Q
                AD      FB1_Q

                XCH     FB1_Q       #  FB1_Q0 = Q, A = P0+Q0 --> FB1_Q = P0+Q0 (=Q1), A = Q0
                AD      FB1_Q       #  A = P0+Q0             --> A = P0+2*Q0 (=P1)
                TS      FB1_P

                TCF     FB1_LOOP    #  Return to beginning of loop


#  Return to caller

FB1_FINI        EXTEND              #  Restore the return address.
                QXCH    FB_Q1
                RETURN


#  ==================================
#  Routine to compute cumulative sums
#  ==================================

#  Inputs:
#     A:         Value for which the cumulative sum is to be computed

#     FB_NUMBP:  Number of breakpoints
#     FB_Nxx:    Table of locations of breakpoints
#     FB_Vxx:    Table of values of breakpoints

#  Outputs:
#     A:         Cumululative sum for input argument

FB2_N           EQUALS  FB_TMP2

FB2_CSUM        EQUALS  FB_TMP3
FB2_LOC         EQUALS  FB_TMP4
FB2_OFFS        EQUALS  FB_TMP5

FB2_IDX         EQUALS  FB_TMP6
FB2_KEY0        EQUALS  FB_TMP7


#  Define alias
FB2_STRD        EQUALS  FB2_KEY0          #  Alias FB2_KEY0 and FB2_STRD.
                                          #  Their purposes are distinct but values are the same.


FB2_SUB         TS      FB2_N             #  Save argument

                CA      S+ZERO            #  Initialize cumulative sum, location and offset to 0
                TS      FB2_CSUM
                TS      FB2_LOC
                TS      FB2_OFFS

                CA      FB_NUMBP          #  Initialize loop index (counts down)
                TS      FB2_IDX

FB2_LOP0        CA      FB2_IDX           #  Stop iterating when loop counter reaches zero
                EXTEND
                BZF     FB2_FINI

                EXTEND
                DIM     FB2_IDX           #  Decrement loop counter

                INDEX   FB2_IDX           #  Get the current breakpoint location
                CA      FB_N00
                TS      FB2_KEY0          #  Store breakpoint location.
                                          #  (This also sets FB2_STRD which is aliased to FB2_KEY0.)

FB2_LOP1        CA      FB2_LOC           #  Break out of inner loop if adding stride to location
                                          #  takes us past the requested location
                AD      FB2_STRD
                EXTEND
                SU      FB2_N

                EXTEND
                BZMF    FB2_LBL0
                TCF     FB2_LOP0

FB2_LBL0        INDEX   FB2_IDX           #  Add 'triangle' component of interval to cum sum
                CA      FB_S00
                AD      FB2_CSUM
                TS      FB2_CSUM

                CA      FB2_OFFS          #  Add 'rectangle' component of interval to cum sum
                EXTEND
                MP      FB2_STRD
                CA      L
                AD      FB2_CSUM
                TS      FB2_CSUM

                INDEX   FB2_IDX           #  Update the height of 'rectangular' component of interval
                CA      FB_V00
                AD      FB2_OFFS
                TS      FB2_OFFS

                CA      FB2_STRD          #  Update location
                AD      FB2_LOC  
                TS      FB2_LOC

                TCF     FB2_LOP1          #  Branch back to beginning of loop


#  Return to caller

FB2_FINI        CA      FB2_CSUM          #  Load answer into accumulator
                RETURN
