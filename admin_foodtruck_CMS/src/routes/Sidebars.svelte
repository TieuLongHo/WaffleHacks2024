<script>
  import { Sidebar, SidebarGroup, SidebarItem, SidebarWrapper, SidebarDropdownItem, SidebarDropdownWrapper } from 'flowbite-svelte';
  import { MapPinAltSolid, ReceiptSolid, HomeSolid } from 'flowbite-svelte-icons';
  let spanClass = 'flex-1 ms-3 whitespace-nowrap';
  // $: activeUrl = $page.url.pathname;
</script>
<Sidebar  >
    <SidebarWrapper>
        <SidebarGroup>
            <SidebarItem label="Home" href="/">
              <svelte:fragment slot="icon">
                <HomeSolid class="w-6 h-6 text-gray-500 transition duration-75 dark:text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white" />
            </svelte:fragment>
            </SidebarItem>
            <SidebarItem label="Locations" href="/locations">
              <svelte:fragment slot="icon">
                <MapPinAltSolid class="w-6 h-6 text-gray-500 transition duration-75 dark:text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white" />
            </svelte:fragment>
            </SidebarItem>
            <SidebarItem label="Dishes" href="/dishes">
              <svelte:fragment slot="icon">
                <ReceiptSolid class="w-6 h-6 text-gray-500 transition duration-75 dark:text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white" />
            </svelte:fragment>
            </SidebarItem>
        </SidebarGroup>
    </SidebarWrapper>
</Sidebar>