// This file is dual licensed under the terms of the Apache License, Version
// 2.0, and the BSD License. See the LICENSE file in the root of this repository
// for complete details.

// Work-around for https://github.com/PyO3/pyo3/issues/3561
#![allow(unknown_lints, clippy::unnecessary_fallible_conversions)]

#[pyo3::prelude::pymodule]
fn _rust(_py: pyo3::Python<'_>, _m: &pyo3::types::PyModule) -> pyo3::PyResult<()> {
    Ok(())
}
