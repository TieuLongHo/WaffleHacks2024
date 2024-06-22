<script lang="ts">
	import { onMount } from 'svelte';

	let events = [];
	let eventName = '';
	let startDate = '';
	let endDate = '';
	let message = '';

	async function fetchEvents() {
		try {
			const response = await fetch('http://127.0.0.1:5000/event');
			if (!response.ok) {
				throw new Error('Failed to fetch events');
			}
			events = await response.json();
		} catch (error) {
			console.error(error);
			message = 'Failed to load events.';
		}
	}

	async function submitForm(event) {
		event.preventDefault();

		const eventData = {
			name: eventName,
			start_date: startDate,
			end_date: endDate
		};

		const response = await fetch('http://127.0.0.1:5000/event', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(eventData)
		});

		if (response.ok) {
			message = 'Event added successfully!';
			eventName = '';
			startDate = '';
			endDate = '';
			await fetchEvents();
		} else {
			message = 'Failed to add event.';
		}
	}

	onMount(fetchEvents);
</script>

<main class="container mx-auto p-4">
	<h1 class="mb-4 text-2xl font-bold">Add New Event</h1>
	<form on:submit={submitForm}>
		<div class="mb-4">
			<label class="block text-sm font-medium text-gray-700" for="event-name">Event Name</label>
			<input
				type="text"
				id="event-name"
				class="mt-1 block w-full rounded-md border border-gray-300 p-2"
				bind:value={eventName}
				required
			/>
		</div>
		<div class="mb-4">
			<label class="block text-sm font-medium text-gray-700" for="start-date">Start Date</label>
			<input
				type="date"
				id="start-date"
				class="mt-1 block w-full rounded-md border border-gray-300 p-2"
				bind:value={startDate}
				required
			/>
		</div>
		<div class="mb-4">
			<label class="block text-sm font-medium text-gray-700" for="end-date">End Date</label>
			<input
				type="date"
				id="end-date"
				class="mt-1 block w-full rounded-md border border-gray-300 p-2"
				bind:value={endDate}
				required
			/>
		</div>
		<div class="flex justify-end">
			<button type="submit" class="rounded bg-blue-500 px-4 py-2 text-white">Submit</button>
		</div>
	</form>
	{#if message}
		<p class="mt-4">{message}</p>
	{/if}

	<h1 class="mb-4 mt-8 text-2xl font-bold">Events List</h1>
	{#if events.length === 0}
		<p>No events available.</p>
	{:else}
		<ul>
			{#each events as event}
				<li class="mb-2 rounded border p-2">
					<h2 class="text-lg font-bold">{event.name}</h2>
					<p>Start Date: {event.start_date}</p>
					<p>End Date: {event.end_date}</p>
				</li>
			{/each}
		</ul>
	{/if}
</main>

<style>
	.container {
		max-width: 600px;
	}
</style>
