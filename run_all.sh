#!/usr/bin/env bash
set -euo pipefail

echo "Running certificates for the core paper..."
sage core/verify_path_splicing.sage
sage core/verify_scalar_envelope.sage
sage core/verify_local_moment.sage

echo "Running certificates for the applications paper..."
sage applications/verify_line_graph.sage

echo "All SageMath certificates passed."
