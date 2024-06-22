<script>
	import '../app.css';
	import Sidebars from './Sidebars.svelte';
</script>

<div class="flex h-full flex-row">
	<Sidebars />
	<slot></slot>
</div>

<style></style>
