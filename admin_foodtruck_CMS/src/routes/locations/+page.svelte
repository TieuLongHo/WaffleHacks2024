<script lang="ts">
	import { onMount } from 'svelte';
	import { MapLibre, MapEvents, DefaultMarker } from 'svelte-maplibre';

	let locations = [];
	let foodTrucks = [];
	let events = [];
	let loading = true;
	let error = null;
	let markers: { lngLat: number[]; showForm: boolean }[] = [];
	let currentMarker: { lngLat: number[]; showForm: boolean } | null = null;

	let startDate: string;
	let endDate: string;
	let startTimestamp: number;
	let endTimestamp: number;

	onMount(async () => {
		try {
			const [locationsResponse, foodTrucksResponse, eventsResponse] = await Promise.all([
				fetch('http://127.0.0.1:5000/location'),
				fetch('http://127.0.0.1:5000/foodtruck'),
				fetch('http://127.0.0.1:5000/event')
			]);

			if (!locationsResponse.ok) {
				throw new Error('Failed to fetch locations');
			}

			if (!foodTrucksResponse.ok) {
				throw new Error('Failed to fetch food trucks');
			}

			if (!eventsResponse.ok) {
				throw new Error('Failed to fetch events');
			}

			locations = await locationsResponse.json();
			foodTrucks = await foodTrucksResponse.json();
			events = await eventsResponse.json();
		} catch (err) {
			error = err.message;
		} finally {
			loading = false;
			locations.forEach((location) => {
				markers = [
					...markers,
					{ lngLat: [location.longitude, location.latitude], showForm: false }
				];
			});
		}
	});

	function addMarker(e: CustomEvent<MapMouseEvent>) {
		const newMarker = { lngLat: e.detail.lngLat, showForm: true };
		markers = [...markers, newMarker];
		currentMarker = newMarker;
		console.log(e.detail.lngLat);
	}

	function handleDateChange() {
		if (startDate) {
			startTimestamp = new Date(startDate).getTime() / 1000;
		}
		if (endDate) {
			endTimestamp = new Date(endDate).getTime() / 1000;
		}
	}

	async function submitForm(event) {
		event.preventDefault();
		handleDateChange();
		const formData = new FormData(event.target);
		const foodtruck_id = formData.get('foodtruck_id');
		const event_id = formData.get('event_id');

		if (currentMarker) {
			const latitude = currentMarker.lngLat.lng;
			const longitude = currentMarker.lngLat.lat;

			const data = {
				event_id: parseInt(event_id as string, 10),
				foodtruck_id: parseInt(foodtruck_id as string, 10),
				latitude,
				longitude
			};

			console.log(JSON.stringify(data));

			currentMarker.showForm = false;
			currentMarker = null;
		}
	}

	function cancelForm() {
		if (currentMarker) {
			markers = markers.filter((marker) => marker !== currentMarker);
			currentMarker = null;
		}
	}
</script>

<MapLibre
	center={[8.2, 47]}
	zoom={7}
	class="map h-screen"
	standardControls
	style="https://basemaps.cartocdn.com/gl/positron-gl-style/style.json"
>
	<MapEvents on:click={addMarker} />

	{#each markers as marker}
		<DefaultMarker lngLat={marker.lngLat} />
	{/each}
</MapLibre>

{#if currentMarker}
	<div
		class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 backdrop-blur-sm"
	>
		<div class="z-60 rounded-lg bg-white p-6 shadow-lg">
			<form on:submit={submitForm}>
				<div class="mb-4">
					<label class="block text-sm font-medium text-gray-700">
						Food Truck:
						<select
							name="foodtruck_id"
							class="mt-1 block w-full rounded-md border border-gray-300 p-2"
							required
						>
							{#each foodTrucks as foodTruck}
								<option value={foodTruck.id}>{foodTruck.name}</option>
							{/each}
						</select>
					</label>
				</div>
				<div class="mb-4">
					<label class="block text-sm font-medium text-gray-700">
						Event:
						<select
							name="event_id"
							class="mt-1 block w-full rounded-md border border-gray-300 p-2"
							required
						>
							{#each events as event}
								<option value={event.id}>{event.name}</option>
							{/each}
						</select>
					</label>
				</div>
				<div class="mb-4">
					<label class="block text-sm font-medium text-gray-700">
						Start Date:
						<input
							type="date"
							bind:value={startDate}
							class="mt-1 block w-full rounded-md border border-gray-300 p-2"
							required
						/>
					</label>
				</div>
				<div class="mb-4">
					<label class="block text-sm font-medium text-gray-700">
						End Date:
						<input
							type="date"
							bind:value={endDate}
							class="mt-1 block w-full rounded-md border border-gray-300 p-2"
							required
						/>
					</label>
				</div>
				<input type="hidden" name="latitude" value={currentMarker.lngLat[1]} />
				<input type="hidden" name="longitude" value={currentMarker.lngLat[0]} />
				<div class="flex justify-end">
					<button
						type="button"
						on:click={cancelForm}
						class="mr-2 rounded bg-gray-500 px-4 py-2 text-white">Cancel</button
					>
					<button type="submit" class="rounded bg-blue-500 px-4 py-2 text-white">Submit</button>
				</div>
			</form>
		</div>
	</div>
{/if}
