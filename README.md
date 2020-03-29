# repetitive-controller-designer
MATLAB application for projects with repetitive controllers.

-------------------------------------------------------------------------------------------------------------------------------------------

How does it work?

First of all, it is necessary to define the plant to be controlled. This can be done by choosing the transfer function coefficients or by choosing an existing variable in the MATLAB workspace. 

In 'System Stability' it is possible to observe the impact of changing the controller parameters on the system stability. The stability is guaranteed when the Nyquist diagram of the chosen plant is completely contained in the controller stability domain (in blue). NOTE: the 'x' mark indicates where the Nyquist diagram starts.

In 'Filter Design' it is possible to run an algorithm that returns an ideal filter for the system, according to the parameters chosen initially. The curve of this filter indicates the maximum magnitude of the  parameter 'Q(s)' for a given frequency. Thus, when exporting the generated data, the user can design any other filter that respects these limits.

-------------------------------------------------------------------------------------------------------------------------------------------

About app development:

Undergraduate thesis by Pedro Vitor Soares Gomes de Lima

Based on Rafael Cavalcanti Neto's doctoral dissertation

Federal University of Pernambuco - Brazil

Electrical Engineering Department

Note: Both works are in the 'references' folder (written in Portuguese)
