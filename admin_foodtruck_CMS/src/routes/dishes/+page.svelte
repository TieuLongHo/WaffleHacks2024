<script lang="ts">
	import { onMount } from 'svelte';
	import { List, Li } from 'flowbite-svelte';
	import { DollarOutline } from 'flowbite-svelte-icons';

	let dishes = [];
	let loading = true;
	let error = null;

	let truckId = '1';
	let dishName = '';
	let price = '';
	let ingredients = ['']; // Initialize with one empty ingredient input
	let message = '';

	onMount(async () => {
		await fetchDishes();
	});

	async function fetchDishes() {
		try {
			const response = await fetch('http://127.0.0.1:5000/dish');
			if (!response.ok) {
				throw new Error('Failed to fetch dishes');
			}
			dishes = await response.json();
		} catch (err) {
			error = err.message;
		} finally {
			loading = false;
		}
	}

	async function submitForm(event) {
		event.preventDefault();

		const dishData = {
			truck_id: parseInt(truckId),
			name: dishName,
			price: parseFloat(price),
			ingredients: ingredients.filter((ingredient) => ingredient.trim() !== '') // Remove empty ingredients
		};

		const response = await fetch('http://127.0.0.1:5000/dish', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(dishData)
		});

		if (response.ok) {
			message = 'Dish added successfully!';
			truckId = '';
			dishName = '';
			price = '';
			ingredients = [''];
			await fetchDishes();
		} else {
			message = 'Failed to add dish.';
		}
	}

	function addIngredient() {
		ingredients = [...ingredients, ''];
	}

	function removeIngredient(index) {
		ingredients = ingredients.filter((_, i) => i !== index);
	}
</script>

<main class="container mx-auto p-4">
	<div class="mt-36"></div>
	<h1 class="mb-4 text-2xl font-bold">Add New Dish</h1>
	<form on:submit={submitForm}>
		<div class="mb-4">
			<label class="block text-sm font-medium text-gray-700" for="dish-name">Dish Name</label>
			<input
				type="text"
				id="dish-name"
				class="mt-1 block w-full rounded-md border border-gray-300 p-2"
				bind:value={dishName}
				required
			/>
		</div>
		<div class="mb-4">
			<label class="block text-sm font-medium text-gray-700" for="price">Price</label>
			<input
				type="number"
				step="0.01"
				id="price"
				class="mt-1 block w-full rounded-md border border-gray-300 p-2"
				bind:value={price}
				required
			/>
		</div>
		<div class="mb-4">
			<label class="block text-sm font-medium text-gray-700">Ingredients</label>
			{#each ingredients as ingredient, index}
				<div class="mt-2 flex items-center">
					<input
						type="text"
						class="mt-1 block w-full rounded-md border border-gray-300 p-2"
						bind:value={ingredients[index]}
					/>
					{#if ingredients.length > 1}
						<button type="button" class="ml-2 text-red-500" on:click={() => removeIngredient(index)}
							>&times;</button
						>
					{/if}
				</div>
			{/each}
			<button type="button" class="mt-2 text-blue-500" on:click={addIngredient}
				>Add Ingredient</button
			>
		</div>
		<div class="flex justify-end">
			<button type="submit" class="rounded bg-blue-500 px-4 py-2 text-white">Submit</button>
		</div>
	</form>
	{#if message}
		<p class="mt-4">{message}</p>
	{/if}

	<h1 class="mb-4 mt-8 text-2xl font-bold">Dishes List</h1>
	{#if loading}
		<p>Loading...</p>
	{:else if error}
		<p>Error: {error}</p>
	{:else}
		<List tag="ul" list="none" class="divide-y divide-gray-200 dark:divide-gray-700">
			{#each dishes as dish}
				<Li class="pb-3 sm:pb-4">
					<div class="flex items-center space-x-4 rtl:space-x-reverse">
						<div class="flex-shrink-0">
							<DollarOutline
								class="h-6 w-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white"
							/>
						</div>
						<div class="min-w-0 flex-1">
							<p class="text-m truncate font-medium text-gray-900 dark:text-white">{dish.name}</p>
							{#each dish.ingredients as ingredient}
								<p class="text-sm text-gray-500 dark:text-gray-400">{ingredient}</p>
							{/each}
						</div>
						<div
							class="inline-flex items-center text-base font-semibold text-gray-900 dark:text-white"
						>
							CHF{dish.price}
						</div>
					</div>
				</Li>
			{/each}
		</List>
	{/if}
</main>

<style>
	.container {
		max-width: 600px;
	}
</style>
