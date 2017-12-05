## The relationship between body size and sensitivity to habitat loss

##### Current progress:

* 201712/05: using **work\_multi\_logistic_simTau** and **Multi\_Logistictauleap.m** to simulate multi-species logistic function (no interaction)

##### To do:

* cost of short-distance dispersal
* alternative scenarios of habitat loss
* 


## m-files
* **landscape64.m**: script, creating 64-patch coordinates
* **landscape256.m**: script, creating 256-patch coordinates
* **Logistictauleap.m**: function, simulating single-species logistic function
* **LVmetaGillespie4.m**:  function, Gillespie simulation of Lotka-Volterra metacommunities
* **LVtauleap.m**: function, tau-leaping simulation of Lotka-Volterra metacommunities
* **Multi\_Logistictauleap.m**: function, simulating multi-species logistic function (no interaction)
* **plot_snapshot**: function, plotting snapshot of a metacommunity
* **work\_habitatloss.m**: simulation with  **LVmetaGillespie4.m**
* **work\_habitatloss_movie.m**: simulation with  **LVmetaGillespie4.m**, and make movie
* **work\_habitatloss\_sim.m**: simulation with  **LVmetaGillespie4.m** with many iterations and show destiny.
* **work\_habitatloss\_simTau.m**: simulation with  **LVtauleap.m** with many iterations and show destiny.
* **work\_multi\_logistic_simTau**: simulating  multi-species logistic model (no interaction) with **Multi\_Logistictauleap.m**
* **work\_plot\_habitatloss.m**: make plots of "habitat loss" landscapes.
* **work\_plot\_kernel.m**: plot dispersal kernel
* **work\_setup.m**: set path and load tools