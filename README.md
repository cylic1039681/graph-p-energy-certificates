# SageMath certificates for path-minimality of graph (p)-energies

This repository contains the SageMath verification scripts and certificate data
used in the two companion papers

1. **Path-Minimality of $p$-Energy for Connected Graphs**;
2. **Path-Minimality for Positive Graph Energies, Laplacian-Type Spectra, and Line Graphs**.

The computations in this repository verify the finite polynomial, rational,
and interval certificates appearing in the appendices of these papers.  The
checks are designed to be reproducible: the rational certificate checks are
performed over exact rational arithmetic, and the interval checks use
outward-rounded ball arithmetic.

## Contents

The repository is organized as follows.

```text
path-energy-certificates/
├── README.md
├── LICENSE
├── CITATION.cff
├── run_all.sh
├── paper1_core/
│   ├── README.md
│   ├── path_splicing/
│   │   └── verify_all.sage
│   ├── scalar_envelope/
│   │   └── scalar_envelope_certificates.sage
│   ├── local_moment/
│   │   └── local_moment_check.sage
│   └── output_logs/
│       ├── verify_all_output.txt
│       ├── scalar_envelope_output.txt
│       └── local_moment_output.txt
├── paper2_applications/
│   ├── README.md
│   ├── line_graph/
│   │   └── line_graph_scalar_check.sage
│   └── output_logs/
│       └── line_graph_scalar_check_output.txt
└── docs/
    └── certificate_index.md
```

The directory `paper1_core/` contains the scripts used in the proof of the
main path-minimality theorem for adjacency (p)-energy.  The directory
`paper2_applications/` contains the scripts used in the companion paper on
positive (p)-energies, Laplacian-type spectra, and line graphs.

## Requirements

The scripts were tested with

```text
SageMath 10.8
```

They are expected to work with recent versions of SageMath 10.x.  No additional
Python packages are required.

To check your SageMath version, run

```bash
sage --version
```

## Running all checks

From the root directory of the repository, run

```bash
bash run_all.sh
```

The script `run_all.sh` executes all verification scripts for both papers.  If
all checks pass, the final line should be

```text
All SageMath certificates passed.
```

## Running individual checks

The scripts can also be run individually.

For the first paper, run

```bash
sage paper1_core/path_splicing/verify_all.sage
sage paper1_core/scalar_envelope/scalar_envelope_certificates.sage
sage paper1_core/local_moment/local_moment_check.sage
```

For the second paper, run

```bash
sage paper2_applications/line_graph/line_graph_scalar_check.sage
```

The expected outputs are stored in the corresponding `output_logs/`
directories.
