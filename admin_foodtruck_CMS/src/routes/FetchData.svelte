<script>
	import { onMount } from 'svelte';

	export let locations = [];
	export let foodTrucks = [];
	export let events = [];
	export let dishes = [];
	let loading = true;
	let error = null;

	onMount(async () => {
		try {
			const [locationsResponse, foodTrucksResponse, eventsResponse, dishesResponse] =
				await Promise.all([
					fetch('http://127.0.0.1:5000/location'),
					fetch('http://127.0.0.1:5000/foodtruck'),
					fetch('http://127.0.0.1:5000/event'),
					fetch('http://127.0.0.1:5000/dish')
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

			if (!dishesResponse.ok) {
				throw new Error('Failed to fetch dishes');
			}

			locations = await locationsResponse.json();
			foodTrucks = await foodTrucksResponse.json();
			events = await eventsResponse.json();
			dishes = await dishesResponse.json();
		} catch (err) {
			error = err.message;
		} finally {
			loading = false;
		}
	});
</script>

<!-- {#if loading}
	<p>Loading...</p>
{:else if error}
	<p>Error: {error}</p>
{:else}
	<div>
		<h2>Locations</h2>
		<ul>
			{#each locations as location}
				<li>{location.latitude}</li>
			{/each}
		</ul>

		<h2>Food Trucks</h2>
		<ul>
			{#each foodTrucks as foodTruck}
				<li>{foodTruck.name}</li>
			{/each}
		</ul>
		<h2>Events</h2>
		<ul>
			{#each events as event}
				<li>{event.name}</li>
			{/each}
		</ul>
	</div>
{/if} -->
