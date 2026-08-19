<#-- soybean 前端单表列表页模板：输出 views/{模块}/{业务}/index.vue -->
<#-- 状态列使用 StatusSwitch 的条件：启用状态切换、状态字段为字符串类型（'0'/'1' 约定）且为列表列 -->
<#assign statusSwitch = enableStatus && ((statusColumn.javaType)!'') == 'String' && ((statusColumn.list)!false)>
<#-- 是否存在需要 DictTag 渲染的列表字典列（状态开关列除外） -->
<#assign hasListDict = columns?filter(c -> c.list && c.dictType?has_content && !(statusSwitch && c.javaField == statusField))?has_content>
<script setup lang="tsx">
import { ref } from 'vue';
import { NDivider } from 'naive-ui';
import { fetchBatchDelete${BusinessName}, fetchGet${BusinessName}List<#if statusSwitch>, fetchChange${BusinessName}Status</#if> } from '@/service/api/${moduleKebab}/${businessKebab}';
import { useAppStore } from '@/store/modules/app';
import { useAuth } from '@/hooks/business/auth';
<#if enableExport>
import { useDownload } from '@/hooks/business/download';
</#if>
import { defaultTransform, useNaivePaginatedTable, useTableOperate } from '@/hooks/common/table';
<#if dictList?has_content>
import { useDict } from '@/hooks/business/dict';
</#if>
<#if hasListDict>
import DictTag from '@/components/custom/dict-tag.vue';
</#if>
<#if statusSwitch>
import StatusSwitch from '@/components/custom/status-switch.vue';
</#if>
import { $t } from '@/locales';
import ButtonIcon from '@/components/custom/button-icon.vue';
import ${BusinessName}OperateDrawer from './modules/${businessKebab}-operate-drawer.vue';
import ${BusinessName}Search from './modules/${businessKebab}-search.vue';

defineOptions({
  name: '${BusinessName}List'
});
<#if dictList?has_content>

<#list dictList as dict>
useDict('${dict.type}'<#if !dict.immediate>, false</#if>);
</#list>
</#if>

const appStore = useAppStore();
<#if enableExport>
const { download } = useDownload();
</#if>
const { hasAuth } = useAuth();

const searchParams = ref<Api.${ModuleName}.${BusinessName}SearchParams>({
  pageNum: 1,
  pageSize: 10,
<#list columns as column>
<#if column.query && (column.queryType!'') != 'BETWEEN'>
  ${column.javaField}: null,
</#if>
</#list>
  params: {}
});

const { columns, columnChecks, data, getData, getDataByPage, loading, mobilePagination, scrollX } =
  useNaivePaginatedTable({
    api: () => fetchGet${BusinessName}List(searchParams.value),
    transform: response => defaultTransform(response),
    onPaginationParamsChange: params => {
      searchParams.value.pageNum = params.page;
      searchParams.value.pageSize = params.pageSize;
    },
    columns: () => [
      {
        type: 'selection',
        align: 'center',
        width: 48
      },
      {
        key: 'index',
        title: $t('common.index'),
        align: 'center',
        width: 64,
        render: (_, index) => index + 1
      },
<#list columns as column>
<#if column.list>
<#if statusSwitch && column.javaField == statusField>
      {
        key: '${column.javaField}',
        title: '${column.columnLabel}',
        align: 'center',
        minWidth: 120,
        render(row) {
          return (
            <StatusSwitch
              v-model:value={row.${column.javaField}}
              onSubmitted={(value, callback) => handleStatusChange(row, value, callback)}
            />
          );
        }
      },
<#elseif column.dictType?has_content>
      {
        key: '${column.javaField}',
        title: '${column.columnLabel}',
        align: 'center',
        minWidth: 120,
        render(row) {
          return <DictTag size="small" value={row.${column.javaField}} dictCode="${column.dictType}" />;
        }
      },
<#else>
      {
        key: '${column.javaField}',
        title: '${column.columnLabel}',
        align: 'center',
        minWidth: 120
      },
</#if>
</#if>
</#list>
      {
        key: 'operate',
        title: $t('common.operate'),
        align: 'center',
        width: 130,
        render: row => {
          const divider = () => {
            if (!hasAuth('${moduleName}:${businessName}:edit') || !hasAuth('${moduleName}:${businessName}:remove')) {
              return null;
            }
            return <NDivider vertical />;
          };

          const editBtn = () => {
            if (!hasAuth('${moduleName}:${businessName}:edit')) {
              return null;
            }
            return (
              <ButtonIcon
                text
                type="primary"
                icon="material-symbols:drive-file-rename-outline-outline"
                tooltipContent={$t('common.edit')}
                onClick={() => edit(row.${pkColumn.javaField})}
              />
            );
          };

          const deleteBtn = () => {
            if (!hasAuth('${moduleName}:${businessName}:remove')) {
              return null;
            }
            return (
              <ButtonIcon
                text
                type="error"
                icon="material-symbols:delete-outline"
                tooltipContent={$t('common.delete')}
                popconfirmContent={$t('common.confirmDelete')}
                onPositiveClick={() => handleDelete(row.${pkColumn.javaField})}
              />
            );
          };

          return (
            <div class="flex-center gap-8px">
              {editBtn()}
              {divider()}
              {deleteBtn()}
            </div>
          );
        }
      }
    ]
  });

const { drawerVisible, operateType, editingData, handleAdd, handleEdit, checkedRowKeys, onBatchDeleted, onDeleted } =
  useTableOperate(data, '${pkColumn.javaField}', getData);

async function handleBatchDelete() {
  // request
  const { error } = await fetchBatchDelete${BusinessName}(checkedRowKeys.value);
  if (error) return;
  onBatchDeleted();
}

async function handleDelete(${pkColumn.javaField}: CommonType.IdType) {
  // request
  const { error } = await fetchBatchDelete${BusinessName}([${pkColumn.javaField}]);
  if (error) return;
  onDeleted();
}

function edit(${pkColumn.javaField}: CommonType.IdType) {
  handleEdit(${pkColumn.javaField});
}
<#if statusSwitch>

async function handleStatusChange(
  row: Api.${ModuleName}.${BusinessName},
  value: Api.Common.EnableStatus,
  callback: (flag: boolean) => void
) {
  const { error } = await fetchChange${BusinessName}Status(row.${pkColumn.javaField}, value);
  callback(!error);
  if (!error) {
    window.$message?.success($t('common.updateSuccess'));
  }
}
</#if>
<#if enableExport>

function handleExport() {
  download('/${moduleName}/${businessName}/export', searchParams.value, `${functionName}_${r"${new Date().getTime()}"}.xlsx`);
}
</#if>
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <${BusinessName}Search v-model:model="searchParams" @search="getDataByPage" />
    <NCard title="${functionName}列表" :bordered="false" size="small" class="card-wrapper sm:flex-1-hidden">
      <template #header-extra>
        <TableHeaderOperation
          v-model:columns="columnChecks"
          :disabled-delete="checkedRowKeys.length === 0"
          :loading="loading"
          :show-add="hasAuth('${moduleName}:${businessName}:add')"
          :show-delete="hasAuth('${moduleName}:${businessName}:remove')"
<#if enableExport>
          :show-export="hasAuth('${moduleName}:${businessName}:export')"
<#else>
          :show-export="false"
</#if>
          @add="handleAdd"
          @delete="handleBatchDelete"
<#if enableExport>
          @export="handleExport"
</#if>
          @refresh="getData"
        />
      </template>
      <NDataTable
        v-model:checked-row-keys="checkedRowKeys"
        :columns="columns"
        :data="data"
        size="small"
        :flex-height="!appStore.isMobile"
        :scroll-x="scrollX"
        :loading="loading"
        remote
        :row-key="row => row.${pkColumn.javaField}"
        :pagination="mobilePagination"
        class="sm:h-full"
      />
      <${BusinessName}OperateDrawer
        v-model:visible="drawerVisible"
        :operate-type="operateType"
        :row-data="editingData"
        @submitted="getDataByPage"
      />
    </NCard>
  </div>
</template>

<style scoped></style>
