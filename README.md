# Comanche055_DodgeTheLasers
This repo contains a modified version of the software for the guidance computer in Apollo 11's Command Module.  This software has been modified to include the ability to compute answers to the "Dodge the Lasers" problem in the Google FooBar Challenge.

Software for the Apollo program's guidance computers was developed by MIT's Instrumentation Laboratory.  The particular software release from which this repo is derived was named Comanche 55.  The Comanche 55 source code was obtained from the [Virtual Apollo Guidance Computer Project](http://www.ibiblio.org/apollo/index.html).  The software runs on that project's [Apollo Guidance Computer emulator](https://github.com/virtualagc/virtualagc).  If the Apollo 11 crew had needed to solve the "Dodge the Laser's" problem while in transit to and from the moon, this software could have run on the Command Module's computer.


# Motivation
In the context presented by the "Dodge the Lasers" problem statement, you are in a pod escaping from a space station.  In that pod you are to compute sums of approximations of multiples of square root two.  The salient features of this context are (1) computation on (2) a manned spacecraft (3) outside of low earth orbit.  The Apollo spacecraft are the only manned space craft that have operated outside low earth orbit and the computer onboard was the Apollo Guidance Computer (AGC).  Therefore any solution to the Dodge the Lasers problem should be able to run on an AGC.  The software in this repo meets that requirement.


# The "Dodge the Lasers" Problem
The "Dodge the Lasers" problem is one of the Level 5 problems in the Google FooBar Challenge.  The following is the problem statement:

Oh no! You've managed to escape Commander Lambda's collapsing space station in an escape pod with the rescued bunny prisoners - but Commander Lambda isn't about to let you get away that easily. She's sent her elite fighter pilot squadron after you - and they've opened fire!

Fortunately, you know something important about the ships trying to shoot you down. Back when you were still Commander Lambda's assistant, she asked you to help program the aiming mechanisms for the starfighters. They undergo rigorous testing procedures, but you were still able to slip in a subtle bug. The software works as a time step simulation: if it is tracking a target that is accelerating away at 45 degrees, the software will consider the target's acceleration to be equal to the square root of 2, adding the calculated result to the target's end velocity at each timestep. However, thanks to your bug, instead of storing the result with proper precision, it will be truncated to an integer before adding the new velocity to your current position.  This means that instead of having your correct position, the targeting software will erringly report your position as sum(i=1..n, floor(i*sqrt(2))) - not far enough off to fail Commander Lambdas testing, but enough that it might just save your life.

If you can quickly calculate the target of the starfighters' laser beams to know how far off they'll be, you can trick them into shooting an asteroid, releasing dust, and concealing the rest of your escape.  Write a function solution(str_n) which, given the string representation of an integer n, returns the sum of (floor(1*sqrt(2)) + floor(2*sqrt(2)) + ... + floor(n*sqrt(2))) as a string. That is, for every number i in the range 1 to n, it adds up all of the integer portions of i*sqrt(2).

For example, if str_n was "5", the solution would be calculated as
floor(1*sqrt(2)) +
floor(2*sqrt(2)) +
floor(3*sqrt(2)) +
floor(4*sqrt(2)) +
floor(5*sqrt(2))
= 1+2+4+5+7 = 19
so the function would return "19".


# Modifications Made to Comanche 55 Codebase
The Apollo Guidance Computers' memory consisted of 38K total of 15-bit words (a little less than 76K bytes).  This includes 2K words of RAM and 36K words of ROM.  Virtually all ROM was used.  In order to add the logic for the Dodge The Lasers solution some original functionality had to be removed.

Upon inspection of the codebase, the decision was made to sacrifice part of the self-test logic, specifically the portion which computes the checksums of the memory banks.  Since the astronaut can directly invoke the routines to compute the checksums of the banks of ROM, an added benefit of this choice is that no additional modifications were necessary in order to provide the means to run the new Dodge the Lasers code.

The human-machine interface provided by the Apollo Guidance Computer is based on Verbs and Nouns.  Verbs specify what operation needs to be done and Nouns specify on what.  Nouns and Verbs are two digit numbers.  To invoke the routines to compute the ROM checksums, the astronaut would enter a value of 91 for the Verb.  (No Noun was necessary because what the routine operated on, the memory banks, was fixed.)  The routine would compute the checksums for memory banks one at a time and pause to display the result.  The astronaut would continue to the next memory bank by entering Verb 33.  Entering the Verb 34 terminated the checksum computation process.

Just as what the memory bank checksum routine operated on was fixed, so too is what the Dodge the Lasers solution operates on.  The first iteration of the new code computes the solution to the problem for an input value of 128.  The second iteration computes the solution for an input of 129, the third iteration for 130 and so on.  The initial value of 128 was chosen because it is easily generated and produces an answer large enough to be avoid being trivial and yet still display on the computer's four digit display.

# Compiling and running the code
Compiling and running the code depends on the compiler and emulator in the [Virtual Apollo Guidance Computer Project](http://www.ibiblio.org/apollo/index.html).  Once you are able to compile and run the AGC code in that project, all that is necessary to compile and build the software in this repo is to replace the Comanche055 directory in the Virtual AGC source tree with the directory in this repo and rebuild the Virtual Apollo Guidance Computer's binaries.
