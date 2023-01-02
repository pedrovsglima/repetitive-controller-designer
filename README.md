# repetitive-controller-designer
MATLAB application for projects with repetitive controllers.

Available in: https://www.mathworks.com/matlabcentral/fileexchange/74759-repetitive-controller-designer

-------------------------------------------------------------------------------------------------------------------------------------------

HOW DOES IT WORK?

First of all, it is necessary to define the plant to be controlled. This can be done either by choosing the transfer function coefficients or by choosing an existing variable in the MATLAB workspace. 

In 'System Stability' it is possible to observe the impact of changing the controller parameters on the system stability. The stability is guaranteed when the Nyquist diagram of the chosen plant is completely contained in the controller stability domain (in blue). NOTE: the 'x' mark indicates where the Nyquist diagram starts.

In 'Filter Design' it is possible to run an algorithm that returns an ideal filter for the system, according to the parameters chosen initially. The curve of this filter indicates the maximum magnitude of the parameter 'Q(z)' for a given frequency. Thus, when exporting the generated data, the user can design any other filter that respects these limits.


-------------------------------------------------------------------------------------------------------------------------------------------

ABOUT APP DEVELOPMENT:

The primitive repetitive cell used in this app is described in "[R. C. Neto, F. A. S. Neves and H. E. P. De Souza, "Unified Approach to Evaluation of Real and Complex Repetitive Controllers," in IEEE Access, vol. 9, pp. 47960-47975, 2021, doi: 10.1109/ACCESS.2021.3068680](https://ieeexplore.ieee.org/document/9385094)".

Universidade Federal de Pernambuco - UFPE (Federal University of Pernambuco - Brazil)

Departamento de Engenharia Elétrica - DEE (Department of Electrical Engineering)




-------------------------------------------------------------------------------------------------------------------------------------------

MATLAB RELEASE COMPATIBILITY:

Created with R2016a

Compatible with any release
