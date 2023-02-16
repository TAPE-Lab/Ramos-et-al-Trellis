# Ramos-et-al-Trellis

This library runs code associated with the Trellis paper which is on [BioRxiv](https://www.biorxiv.org/content/10.1101/2022.10.19.512668v1).
Code to reproduce the figures in the paper can be found on the [TapeLab's github repo](https://github.com/TAPE-Lab/Ramos-et-al-Trellis). Note that an earlier version of [MultiscaleEMD](https://github.com/atong01/MultiscaleEMD/) was used to run these experiments. Installing this version can be accomplished by downloading the source at [this commit](https://github.com/atong01/MultiscaleEMD/tree/35f91c1aa4a209638d5884ea32afba64fe6a4960) and installing with :code:`pip install -e .` from the :code:`MultiscaleEMD` directory.

In brief, Trellis is a method to compare single-cell dataset distributions
under different treatment conditions while normalizing for multiple controls.
Paired Trellis implements a Kantorovich-Rubenstein distance with tree ground
distance allowing for a normalization step against a specified control per
treatment. 
    
A short [how-to tutorial](https://github.com/MariaRamosZ/Trellis_how_to/) on Trellis is available, with associated notebook hosted on Kaggle [here](https://www.kaggle.com/code/mariaramosz/trellis).
