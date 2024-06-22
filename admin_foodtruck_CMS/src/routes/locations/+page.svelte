<script lang="ts">
    let markers: { lngLat: number[] }[] = [];
    import { MapLibre, MapEvents, DefaultMarker} from 'svelte-maplibre';
    function addMarker(e: CustomEvent<MapMouseEvent>) {
  markers = [...markers, { lngLat: e.detail.lngLat }];
  console.log(e.detail.lngLat);
}
  </script>
  
  <MapLibre 
    center={[8.2,47]}
    zoom={7}
    class="map"
    standardControls
    style="https://basemaps.cartocdn.com/gl/positron-gl-style/style.json">

  <MapEvents on:click={addMarker} />

  {#each markers as marker}
    <DefaultMarker lngLat={marker.lngLat} />
  {/each}
</MapLibre>
  
  <style>
    :global(.map) {
      height: 500px;
    }
  </style>