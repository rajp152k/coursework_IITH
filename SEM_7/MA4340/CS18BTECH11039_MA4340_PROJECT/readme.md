# MA4340 : Project 
# Option Pricing via Monte Carlo Simulations

## Author

| Name      | Roll no.       |
| Raj Patil | CS18BTECH11039 |


## Deliverables:

CS18BTECH11039_MA4340_PROJECT/
├── exp_res_plots                 --> plots of experiments carried out
│  ├── call_antithetic.png
│  ├── call_gran.png
│  ├── call_num_sim.png
│  ├── gran_ste.png
│  ├── num_sim_ste.png
│  ├── put_antithetic.png
│  ├── put_gran.png
│  └── put_num_sim.png
├── base_experiments             --> data store for the experiments
│  ├── antithetic_call.csv
│  ├── antithetic_put.csv
│  ├── granularity_call.csv
│  ├── granularity_put.csv
│  ├── num_sim_call.csv
│  └── num_sim_put.csv
├── mc_option_pricing.py        --> CODE 
├── presentation.pdf            --> brief presentation
└── readme.md                   --> this file


## Context and Usage

 - the presentation covers some basics that are used in the code and
   gives a conceptual overview of the theme of this project
 - the code contains the monte-carlo pricer for European calls/puts
   along with an experiment class that will be called when running the
   program
 - run `python mc_option_pricing.py -h` to know more about the valid
   parameters the program receives
 - to produce the results, remember to call with the `--test_all` flag
   - note that there is not point in only setting the `--exp_dir` flag
     without explicitly calling the `--test_all` flag
 - results will be dumped csv files will be dumped into the exp_dir provided (`./experiments` by default) 
