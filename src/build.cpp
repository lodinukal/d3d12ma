#include "D3D12MemAlloc.h"
#include "D3D12MemAlloc.cpp"

// here because I want to minimise the changes to the original code

d3d12ma_no_name_mangle HRESULT D3D12MAAllocation_QueryInterface(void *pSelf, REFIID riid, void **ppvObject)
{
    return static_cast<D3D12MA::Allocation *>(pSelf)->QueryInterface(riid, ppvObject);
}
d3d12ma_no_name_mangle ULONG D3D12MAAllocation_AddRef(void *pSelf)
{
    return static_cast<D3D12MA::Allocation *>(pSelf)->AddRef();
}
d3d12ma_no_name_mangle ULONG D3D12MAAllocation_Release(void *pSelf)
{
    return static_cast<D3D12MA::Allocation *>(pSelf)->Release();
}

d3d12ma_no_name_mangle HRESULT D3D12MADefragmentationContext_QueryInterface(void *pSelf, REFIID riid, void **ppvObject)
{
    return static_cast<D3D12MA::DefragmentationContext *>(pSelf)->QueryInterface(riid, ppvObject);
}
d3d12ma_no_name_mangle ULONG D3D12MADefragmentationContext_AddRef(void *pSelf)
{
    return static_cast<D3D12MA::DefragmentationContext *>(pSelf)->AddRef();
}
d3d12ma_no_name_mangle ULONG D3D12MADefragmentationContext_Release(void *pSelf)
{
    return static_cast<D3D12MA::DefragmentationContext *>(pSelf)->Release();
}

d3d12ma_no_name_mangle HRESULT D3D12MAPool_QueryInterface(void *pSelf, REFIID riid, void **ppvObject)
{
    return static_cast<D3D12MA::Pool *>(pSelf)->QueryInterface(riid, ppvObject);
}
d3d12ma_no_name_mangle ULONG D3D12MAPool_AddRef(void *pSelf)
{
    return static_cast<D3D12MA::Pool *>(pSelf)->AddRef();
}
d3d12ma_no_name_mangle ULONG D3D12MAPool_Release(void *pSelf)
{
    return static_cast<D3D12MA::Pool *>(pSelf)->Release();
}

d3d12ma_no_name_mangle HRESULT
D3D12MAAllocator_QueryInterface(void *pSelf, REFIID riid, void **ppvObject)
{
    return static_cast<D3D12MA::Allocator *>(pSelf)->QueryInterface(riid, ppvObject);
}
d3d12ma_no_name_mangle ULONG D3D12MAAllocator_AddRef(void *pSelf)
{
    return static_cast<D3D12MA::Allocator *>(pSelf)->AddRef();
}
d3d12ma_no_name_mangle ULONG D3D12MAAllocator_Release(void *pSelf)
{
    return static_cast<D3D12MA::Allocator *>(pSelf)->Release();
}

d3d12ma_no_name_mangle HRESULT
D3D12MAVirtualBlock_QueryInterface(void *pSelf, REFIID riid, void **ppvObject)
{
    return static_cast<D3D12MA::VirtualBlock *>(pSelf)->QueryInterface(riid, ppvObject);
}
d3d12ma_no_name_mangle ULONG D3D12MAVirtualBlock_AddRef(void *pSelf)
{
    return static_cast<D3D12MA::VirtualBlock *>(pSelf)->AddRef();
}
d3d12ma_no_name_mangle ULONG D3D12MAVirtualBlock_Release(void *pSelf)
{
    return static_cast<D3D12MA::VirtualBlock *>(pSelf)->Release();
}