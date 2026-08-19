<#-- soybean 前端 API 模板：输出 service/api/{模块}/{业务}.ts，URL 中模块名保持原样以匹配网关路由前缀 -->
import { request } from '@/service/request';

/** 获取${functionName}列表 */
export function fetchGet${BusinessName}List(params?: Api.${ModuleName}.${BusinessName}SearchParams) {
  return request<<#if table.tree>Api.${ModuleName}.${BusinessName}[]<#else>Api.${ModuleName}.${BusinessName}List</#if>>({
    url: '/${moduleName}/${businessName}/list',
    method: 'get',
    params
  });
}

/** 新增${functionName} */
export function fetchCreate${BusinessName}(data: Api.${ModuleName}.${BusinessName}OperateParams) {
  return request<boolean>({
    url: '/${moduleName}/${businessName}',
    method: 'post',
    data
  });
}

/** 修改${functionName} */
export function fetchUpdate${BusinessName}(data: Api.${ModuleName}.${BusinessName}OperateParams) {
  return request<boolean>({
    url: '/${moduleName}/${businessName}',
    method: 'put',
    data
  });
}
<#if enableStatus>

/** 修改${functionName}状态 */
export function fetchChange${BusinessName}Status(${pkColumn.javaField}: CommonType.IdType, ${statusField}: <#if statusColumn.javaType == 'Boolean'>boolean<#elseif statusColumn.javaType == 'String'>string<#else>number</#if>) {
  return request<boolean>({
    url: '/${moduleName}/${businessName}/changeStatus',
    method: 'put',
    data: { ${pkColumn.javaField}, ${statusField} }
  });
}
</#if>
<#if enableSort>

/** 调整${functionName}排序 */
export function fetchUpdate${BusinessName}Sort(${pkColumn.javaField}: CommonType.IdType, ${sortField}: <#if sortColumn.javaType == 'String' || sortColumn.javaType == 'LocalDateTime'>string<#else>number</#if>) {
  return request<boolean>({
    url: '/${moduleName}/${businessName}/updateSort',
    method: 'put',
    data: { ${pkColumn.javaField}, ${sortField} }
  });
}
</#if>

/** 批量删除${functionName} */
export function fetchBatchDelete${BusinessName}(${pkColumn.javaField}s: CommonType.IdType[]) {
  return request<boolean>({
    url: `/${moduleName}/${businessName}/${r"${"}${pkColumn.javaField}s.join(',')}`,
    method: 'delete'
  });
}
