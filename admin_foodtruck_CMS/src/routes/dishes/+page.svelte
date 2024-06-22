<script>
	import { onMount } from 'svelte';
	import { List, Li } from 'flowbite-svelte';
	import { DollarOutline } from 'flowbite-svelte-icons';

	export let dishes = [];
	let loading = true;
	let error = null;

	onMount(async () => {
		try {
			const [dishesResponse] = await Promise.all([fetch('http://127.0.0.1:5000/dish')]);

			if (!dishesResponse.ok) {
				throw new Error('Failed to fetch dishes');
			}

			dishes = await dishesResponse.json();
		} catch (err) {
			error = err.message;
		} finally {
			loading = false;
		}
	});
</script>

{#if loading}
	<p>Loading...</p>
{:else if error}
	<p>Error: {error}</p>
{:else}
	<List tag="ul" list="none" class="max-w-md divide-y divide-gray-200 dark:divide-gray-700">
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
