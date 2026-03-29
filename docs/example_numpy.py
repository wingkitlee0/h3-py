import time

import h3
import h3.api
import numpy as np

N = 500_000


def main():
    data = {
        "lat": 40.0 + np.random.rand(N),
        "lon": -130.0 + np.random.rand(N),
    }

    for name, f in [
        ("basic_int", h3.api.basic_int.latlngs_to_cells),
        ("basic_str", h3.api.basic_str.latlngs_to_cells),
        ("numpy_int", h3.api.numpy_int.latlngs_to_cells),
        ("memview_int", h3.api.memview_int.latlngs_to_cells),
        ("vectorized_int", h3.api.experimental_vectorized_int.latlngs_to_cells),
        ("vectorized_str", h3.api.experimental_vectorized_str.latlngs_to_cells),
    ]:
        time_start = time.perf_counter()
        cells = f(data["lat"], data["lon"], res=10)
        time_end = time.perf_counter()

        print(f"h3.api.{name}.latlngs_to_cells taken: {(time_end-time_start):0.3f}s")
        print(f"{type(cells)=}")
        print(f"{cells[:4]}")

        if isinstance(cells, np.ndarray) and cells.dtype == np.uint64:
            print([np.base_repr(int(cell), base=16).lower() for cell in cells[:4]])


if __name__ == "__main__":
    main()