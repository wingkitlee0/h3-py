"""Example to plot the H3 hexagons using plotly interactively
"""

import json

import geopandas
import h3
import numpy as np
import plotly.express as px

outer = [(37.804, -122.412), (37.778, -122.507), (37.733, -122.501)]

poly = h3.H3Poly(outer)

# Convert the H3Ploy object into a list of H3 cells
cells = h3.h3shape_to_cells(poly, res=9)

shapes = [h3.cells_to_h3shape([cell]) for cell in cells]
df = geopandas.GeoDataFrame({"geometry": shapes}, crs="EPSG:3857")
df.loc[:, "value"] = np.random.rand(len(df))
df.index = cells

fig = px.choropleth_mapbox(
    data_frame=df,
    geojson=json.loads(df.to_json()),
    locations=df.index,
    color="value",
    mapbox_style="carto-positron",
    zoom=11,
    center={"lat": 37.778, "lon": -122.507},
)
fig.update_layout(margin={"r": 0, "t": 0, "l": 0, "b": 0})
fig.show()
