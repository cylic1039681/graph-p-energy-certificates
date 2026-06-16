#!/usr/bin/env bash
set -euo pipefail

echo "Running path-splicing certificates..."
sage core/verify_path_splicing.sage | tee core/verify_path_splicing_output.txt

echo "Running scalar-envelope certificates..."
sage core/verify_scalar_envelope.sage | tee core/verify_scalar_envelope_output.txt

echo "Running local-moment certificates..."
sage core/verify_local_moment.sage | tee core/verify_local_moment_output.txt

echo "Running line-graph certificates..."
sage applications/verify_line_graph.sage | tee applications/verify_line_graph_output.txt

echo "All SageMath certificates passed."
