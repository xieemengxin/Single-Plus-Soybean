<#-- soybean 前端类型声明模板：输出 typings/api/{模块}.{业务}.api.d.ts -->
<#assign businessWords = businessKebab?replace('-', ' ')>
<#-- CommonRecord 已包含创建/更新公共字段，此处排除 -->
<#assign baseEntityFields = ['createDept', 'createBy', 'createTime', 'updateBy', 'updateTime']>
<#assign recordColumns = columns?filter(c -> !baseEntityFields?seq_contains(c.javaField))>
<#-- BETWEEN 范围查询通过 params.beginXxx/endXxx 传递，不进入查询参数类型 -->
<#assign queryColumns = columns?filter(c -> c.query && (c.queryType!'') != 'BETWEEN')>
<#assign operateColumns = columns?filter(c -> c.insert || c.edit)>
/**
 * Namespace Api
 *
 * All backend api type
 */
declare namespace Api {
  /**
   * namespace ${ModuleName}
   *
   * backend api module: "${ModuleName}"
   */
  namespace ${ModuleName} {
    /** ${businessWords} */
    type ${BusinessName} = Common.CommonRecord<{
<#list recordColumns as column>
      /** ${column.columnComment!''} */
      ${column.javaField}: <#if column.javaField?contains('id') || column.javaField?contains('Id')>CommonType.IdType<#elseif ['Long', 'Integer', 'Double', 'Float', 'BigDecimal']?seq_contains(column.javaType!'')>number<#elseif (column.javaType!'') == 'Boolean'>boolean<#else>string</#if>;
</#list>
    }>;

    /** ${businessWords} search params */
    type ${BusinessName}SearchParams = CommonType.RecordNullable<
<#if queryColumns?has_content>
      Pick<Api.${ModuleName}.${BusinessName}, <#list queryColumns as column>'${column.javaField}'<#sep> | </#sep></#list>> & Api.Common.CommonSearchParams
<#else>
      Api.Common.CommonSearchParams
</#if>
    >;

    /** ${businessWords} operate params */
    type ${BusinessName}OperateParams = CommonType.RecordNullable<
<#if operateColumns?has_content>
      Pick<Api.${ModuleName}.${BusinessName}, <#list operateColumns as column>'${column.javaField}'<#sep> | </#sep></#list>>
<#else>
      Record<string, never>
</#if>
    >;

    /** ${businessWords} list */
    type ${BusinessName}List = Api.Common.PaginatingQueryRecord<${BusinessName}>;
  }
}
