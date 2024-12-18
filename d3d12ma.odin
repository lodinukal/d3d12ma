package d3d12ma

import windows "core:sys/windows"
import "vendor:directx/d3d12"
import "vendor:directx/dxgi"

Pool :: struct {
	using #subtype iunknown: d3d12.IUnknown,
}
AllocHandle :: distinct u64
AllocateFunctionType :: proc "c" (size: uint, alignment: uint, private_data: rawptr) -> rawptr
FreeFunctionType :: proc "c" (ptr: rawptr, private_data: rawptr)
ALLOCATION_CALLBACKS :: struct {
	pAllocate:    ^AllocateFunctionType,
	pFree:        ^FreeFunctionType,
	pPrivateData: rawptr,
}

ALLOCATION_FLAG :: enum i32 {
	COMMITTED           = 0,
	NEVER_ALLOCATE      = 1,
	WITHIN_BUDGET       = 2,
	UPPER_ADDRESS       = 3,
	CAN_ALIAS           = 4,
	STRATEGY_MIN_MEMORY = 16,
	STRATEGY_MIN_TIME   = 17,
	STRATEGY_MIN_OFFSET = 18,
}
ALLOCATION_FLAGS :: bit_set[ALLOCATION_FLAG;u32]

ALLOCATION_DESC :: struct {
	Flags:          ALLOCATION_FLAGS,
	HeapType:       d3d12.HEAP_TYPE,
	ExtraHeapFlags: d3d12.HEAP_FLAGS,
	CustomPool:     ^Pool,
	pPrivateData:   rawptr,
}

Statistics :: struct {
	BlockCount:      u32,
	AllocationCount: u32,
	BlockBytes:      u64,
	AllocationBytes: u64,
}

DetailedStatistics :: struct {
	Stats:              Statistics,
	UnusedRangeCount:   u32,
	AllocationSizeMin:  u64,
	AllocationSizeMax:  u64,
	UnusedRangeSizeMin: u64,
	UnusedRangeSizeMax: u64,
}

TotalStatistics :: struct {
	HeapType:           [5]DetailedStatistics,
	MemorySegmentGroup: [2]DetailedStatistics,
	Total:              DetailedStatistics,
}

Budget :: struct {
	Stats:       Statistics,
	UsageBytes:  u64,
	BudgetBytes: u64,
}

VirtualAllocation :: struct {
	AllocHandle: AllocHandle,
}

Allocation :: struct {
	using #subtype iunknown: d3d12.IUnknown,
}

DEFRAGMENTATION_FLAG :: enum i32 {
	ALGORITHM_FAST     = 0,
	ALGORITHM_BALANCED = 1,
	ALGORITHM_FULL     = 2,
}
DEFRAGMENTATION_FLAGS :: bit_set[DEFRAGMENTATION_FLAG;u32]

DEFRAGMENTATION_DESC :: struct {
	Flags:                 DEFRAGMENTATION_FLAGS,
	MaxBytesPerPass:       u64,
	MaxAllocationsPerPass: u32,
}

DEFRAGMENTATION_MOVE_OPERATION :: enum i32 {
	COPY    = 0,
	IGNORE  = 1,
	DESTROY = 2,
}

DEFRAGMENTATION_MOVE :: struct {
	Operation:         DEFRAGMENTATION_MOVE_OPERATION,
	pSrcAllocation:    ^Allocation,
	pDstTmpAllocation: ^Allocation,
}

DEFRAGMENTATION_PASS_MOVE_INFO :: struct {
	MoveCount: u32,
	pMoves:    [^]DEFRAGMENTATION_MOVE,
}

DEFRAGMENTATION_STATS :: struct {
	BytesMoved:       u64,
	BytesFreed:       u64,
	AllocationsMoved: u32,
	HeapsFreed:       u32,
}

DefragmentationContext :: struct {
	using #subtype iunknown: d3d12.IUnknown,
}

POOL_FLAG :: enum i32 {
	ALGORITHM_LINEAR               = 0,
	MSAA_TEXTURES_ALWAYS_COMMITTED = 1,
}
POOL_FLAGS :: bit_set[POOL_FLAG;u32]

POOL_DESC :: struct {
	Flags:                  POOL_FLAGS,
	HeapProperties:         d3d12.HEAP_PROPERTIES,
	HeapFlags:              d3d12.HEAP_FLAGS,
	BlockSize:              u64,
	MinBlockCount:          u32,
	MaxBlockCount:          u32,
	MinAllocationAlignment: u64,
	pProtectedSession:      ^d3d12.IProtectedResourceSession,
	ResidencyPriority:      d3d12.RESIDENCY_PRIORITY,
}

ALLOCATOR_FLAG :: enum i32 {
	SINGLETHREADED                      = 0,
	ALWAYS_COMMITTED                    = 1,
	DEFAULT_POOLS_NOT_ZEROED            = 2,
	MSAA_TEXTURES_ALWAYS_COMMITTED      = 3,
	DONT_PREFER_SMALL_BUFFERS_COMMITTED = 4,
}
ALLOCATOR_FLAGS :: bit_set[ALLOCATOR_FLAG;u32]

ALLOCATOR_DESC :: struct {
	Flags:                ALLOCATOR_FLAGS,
	pDevice:              ^d3d12.IDevice,
	PreferredBlockSize:   u64,
	pAllocationCallbacks: ^ALLOCATION_CALLBACKS,
	pAdapter:             ^dxgi.IAdapter,
}

Allocator :: struct {
	using #subtype iunknown: d3d12.IUnknown,
}

VIRTUAL_BLOCK_FLAG :: enum i32 {
	ALGORITHM_LINEAR = 1,
}
VIRTUAL_BLOCK_FLAGS :: bit_set[VIRTUAL_BLOCK_FLAG;u32]

VIRTUAL_BLOCK_DESC :: struct {
	Flags:                VIRTUAL_BLOCK_FLAGS,
	Size:                 u64,
	pAllocationCallbacks: ^ALLOCATION_CALLBACKS,
}

VIRTUAL_ALLOCATION_FLAG :: enum i32 {
	UPPER_ADDRESS       = 3,
	STRATEGY_MIN_MEMORY = 16,
	STRATEGY_MIN_TIME   = 17,
	STRATEGY_MIN_OFFSET = 18,
}
VIRTUAL_ALLOCATION_FLAGS :: bit_set[VIRTUAL_ALLOCATION_FLAG;u32]

VIRTUAL_ALLOCATION_DESC :: struct {
	Flags:        VIRTUAL_ALLOCATION_FLAGS,
	Size:         u64,
	Alignment:    u64,
	pPrivateData: rawptr,
}

VIRTUAL_ALLOCATION_INFO :: struct {
	Offset:       u64,
	Size:         u64,
	pPrivateData: ^rawptr,
}

VIRTUAL_BLOCK :: struct {
	using #subtype iunknown: d3d12.IUnknown,
}
when ODIN_OS == .Windows {
	when ODIN_ARCH == .amd64 {
		foreign import d3d12ma "lib/d3d12ma_x64.lib"
	} else when ODIN_ARCH == .x86 {
		foreign import d3d12ma "lib/d3d12ma_x86.lib"
	} else when ODIN_ARCH == .arm64 {
		foreign import d3d12ma "lib/d3d12ma_arm64.lib"
	} else do #panic("Unsupported architecture")
} else do #panic("Unsupported OS")

@(default_calling_convention = "c", link_prefix = "D3D12MA")
foreign d3d12ma {
	Allocation_GetOffset :: proc(alloc: ^Allocation) -> u64 ---
	Allocation_GetAlignment :: proc(alloc: ^Allocation) -> u64 ---
	Allocation_GetSize :: proc(alloc: ^Allocation) -> u64 ---
	Allocation_GetResource :: proc(alloc: ^Allocation) -> ^d3d12.IResource ---
	Allocation_SetResource :: proc(alloc: ^Allocation, resource: ^d3d12.IResource) ---
	Allocation_GetHeap :: proc(alloc: ^Allocation) -> ^d3d12.IHeap ---
	Allocation_SetPrivateData :: proc(alloc: ^Allocation, private_data: rawptr) ---
	Allocation_GetPrivateData :: proc(alloc: ^Allocation) -> rawptr ---
	Allocation_SetName :: proc(alloc: ^Allocation, name: windows.LPCWSTR) ---
	Allocation_GetName :: proc(alloc: ^Allocation) -> windows.LPCWSTR ---
	DefragmentationContext_BeginPass :: proc(ctx: ^DefragmentationContext, pass_info: ^DEFRAGMENTATION_PASS_MOVE_INFO) -> d3d12.HRESULT ---
	DefragmentationContext_EndPass :: proc(ctx: ^DefragmentationContext, pass_info: ^DEFRAGMENTATION_PASS_MOVE_INFO) -> d3d12.HRESULT ---
	DefragmentationContext_GetStats :: proc(ctx: ^DefragmentationContext, stats: ^DEFRAGMENTATION_STATS) ---
	Pool_GetDesc :: proc(pool: ^Pool) -> POOL_DESC ---
	Pool_GetStatistics :: proc(pool: ^Pool, stats: ^Statistics) ---
	Pool_CalculateStatistics :: proc(pool: ^Pool, stats: ^DetailedStatistics) ---
	Pool_SetName :: proc(pool: ^Pool, name: windows.LPCWSTR) ---
	Pool_GetName :: proc(pool: ^Pool) -> windows.LPCWSTR ---
	Pool_BeginDefragmentation :: proc(pool: ^Pool, #by_ptr desc: DEFRAGMENTATION_DESC, ctx: ^^DefragmentationContext) -> d3d12.HRESULT ---
	Allocator_GetD3D12Options :: proc(alloc: ^Allocator) -> ^d3d12.FEATURE_DATA_OPTIONS ---
	Allocator_IsUMA :: proc(alloc: ^Allocator) -> windows.BOOL ---
	Allocator_IsCacheCoherentUMA :: proc(alloc: ^Allocator) -> windows.BOOL ---
	Allocator_IsGPUUploadHeapSupported :: proc(alloc: ^Allocator) -> windows.BOOL ---
	Allocator_GetMemoryCapacity :: proc(alloc: ^Allocator, MemorySegmentGroup: u32) -> u64 ---
	Allocator_CreateResource :: proc(alloc: ^Allocator, #by_ptr alloc_desc: ALLOCATION_DESC, #by_ptr resource_desc: d3d12.RESOURCE_DESC, InitialResourceState: d3d12.RESOURCE_STATES, optimized_clear_value: ^d3d12.CLEAR_VALUE, ppAllocation: ^^Allocation, riidResource: ^windows.IID, ppvResource: ^rawptr) -> d3d12.HRESULT ---
	Allocator_CreateResource2 :: proc(alloc: ^Allocator, #by_ptr alloc_desc: ALLOCATION_DESC, #by_ptr resource_desc: d3d12.RESOURCE_DESC1, InitialResourceState: d3d12.RESOURCE_STATES, optimized_clear_value: ^d3d12.CLEAR_VALUE, ppAllocation: ^^Allocation, riidResource: ^windows.IID, ppvResource: ^rawptr) -> d3d12.HRESULT ---
	// odin doesn't have device10 types
	// Allocator_CreateResource3 :: proc(alloc: ^Allocator, #by_ptr alloc_desc: ALLOCATION_DESC, #by_ptr resource_desc: d3d12.RESOURCE_DESC1, InitialLayout: d3d12.BARRIER_LAYOUT, optimized_clear_value: ^d3d12.CLEAR_VALUE, NumCastableFormats: u32, castable_formats: [^]dxgi.FORMAT, ppAllocation: ^^Allocation, riidResource: ^windows.IID, ppvResource: ^rawptr) -> d3d12.HRESULT ---
	Allocator_AllocateMemory :: proc(alloc: ^Allocator, #by_ptr alloc_desc: ALLOCATION_DESC, #by_ptr alloc_info: d3d12.RESOURCE_ALLOCATION_INFO, ppAllocation: ^^Allocation) -> d3d12.HRESULT ---
	Allocator_CreateAliasingResource :: proc(alloc: ^Allocator, allocation: ^Allocation, AllocationLocalOffset: u64, #by_ptr resource_desc: d3d12.RESOURCE_DESC, InitialResourceState: d3d12.RESOURCE_STATES, optimized_clear_value: ^d3d12.CLEAR_VALUE, riidResource: ^windows.IID, ppvResource: ^rawptr) -> d3d12.HRESULT ---
	Allocator_CreateAliasingResource1 :: proc(alloc: ^Allocator, allocation: ^Allocation, AllocationLocalOffset: u64, #by_ptr resource_desc: d3d12.RESOURCE_DESC1, InitialResourceState: d3d12.RESOURCE_STATES, optimized_clear_value: ^d3d12.CLEAR_VALUE, riidResource: ^windows.IID, ppvResource: ^rawptr) -> d3d12.HRESULT ---
	// odin doesn't have device10 types
	// Allocator_CreateAliasingResource2 :: proc(alloc: ^Allocator, allocation: ^Allocation, AllocationLocalOffset: u64, #by_ptr resource_desc: d3d12.RESOURCE_DESC1, InitialLayout: d3d12.BARRIER_LAYOUT, optimized_clear_value: ^d3d12.CLEAR_VALUE, NumCastableFormats: u32, castable_formats: [^]dxgi.FORMAT, riidResource: ^windows.IID, ppvResource: ^rawptr) -> d3d12.HRESULT ---
	Allocator_CreatePool :: proc(alloc: ^Allocator, #by_ptr pool_desc: POOL_DESC, ppPool: ^^Pool) -> d3d12.HRESULT ---
	Allocator_SetCurrentFrameIndex :: proc(alloc: ^Allocator, FrameIndex: u32) ---
	Allocator_GetBudget :: proc(alloc: ^Allocator, pLocalBudget: ^Budget, pNonLocalBudget: ^Budget) ---
	Allocator_CalculateStatistics :: proc(alloc: ^Allocator, pStats: ^TotalStatistics) ---
	Allocator_BuildStatsString :: proc(alloc: ^Allocator, ppStatsString: ^^windows.LPCWSTR, DetailedMap: windows.BOOL) ---
	Allocator_FreeStatsString :: proc(alloc: ^Allocator, pStatsString: windows.LPCWSTR) ---
	Allocator_BeginDefragmentation :: proc(alloc: ^Allocator, #by_ptr desc: DEFRAGMENTATION_DESC, ppContext: ^^DefragmentationContext) ---
	VirtualBlock_IsEmpty :: proc(block: ^VIRTUAL_BLOCK) -> windows.BOOL ---
	VirtualBlock_GetAllocationInfo :: proc(block: ^VIRTUAL_BLOCK, Allocation: VirtualAllocation, pInfo: ^VIRTUAL_ALLOCATION_INFO) ---
	VirtualBlock_Allocate :: proc(block: ^VIRTUAL_BLOCK, #by_ptr desc: VIRTUAL_ALLOCATION_DESC, pAllocation: ^^VirtualAllocation, pOffset: ^u64) -> d3d12.HRESULT ---
	VirtualBlock_FreeAllocation :: proc(block: ^VIRTUAL_BLOCK, Allocation: VirtualAllocation) ---
	VirtualBlock_Clear :: proc(block: ^VIRTUAL_BLOCK) ---
	VirtualBlock_SetAllocationPrivateData :: proc(block: ^VIRTUAL_BLOCK, Allocation: VirtualAllocation, pPrivateData: rawptr) ---
	VirtualBlock_GetStatistics :: proc(block: ^VIRTUAL_BLOCK, pStats: ^Statistics) ---
	VirtualBlock_CalculateStatistics :: proc(block: ^VIRTUAL_BLOCK, pStats: ^DetailedStatistics) ---
	VirtualBlock_BuildStatsString :: proc(block: ^VIRTUAL_BLOCK, ppStatsString: ^windows.LPCWSTR) ---
	VirtualBlock_FreeStatsString :: proc(block: ^VIRTUAL_BLOCK, pStatsString: windows.LPCWSTR) ---
	CreateAllocator :: proc(#by_ptr desc: ALLOCATOR_DESC, ppAllocator: ^^Allocator) -> d3d12.HRESULT ---
	CreateVirtualBlock :: proc(#by_ptr desc: VIRTUAL_BLOCK_DESC, ppVirtualBlock: ^^VIRTUAL_BLOCK) -> d3d12.HRESULT ---
}
