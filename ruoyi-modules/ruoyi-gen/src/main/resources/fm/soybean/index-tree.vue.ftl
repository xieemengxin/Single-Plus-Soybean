<#-- soybean 前端树表列表页模板：输出 views/{模块}/{业务}/index.vue -->
<#-- 是否存在需要 DictTag 渲染的列表字典列 -->
<#assign hasListDict = columns?filter(c -> c.list && c.dictType?has_content)?has_content>
<script setup lang="tsx">
import { ref } from 'vue';
import { NDivider } from 'naive-ui';
import { jsonClone } from '@sa/utils';
import { fetchBatchDelete${BusinessName}, fetchGet${BusinessName}List } from '@/service/api/${moduleKebab}/${businessKebab}';
import { useAppStore } from '@/store/modules/app';
import { useAuth } from '@/hooks/business/auth';
import { treeTransform, useNaiveTreeTable, useTableOperate } from '@/hooks/common/table';
<#if enableExport>
import { useDownload } from '@/hooks/business/download';
</#if>
<#if dictList?has_content>
import { useDict } from '@/hooks/business/dict';
</#if>
<#if hasListDict>
import DictTag from '@/components/custom/dict-tag.vue';
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
<#list columns as column>
<#if column.query && (column.queryType!'') != 'BETWEEN'>
  ${column.javaField}: null,
</#if>
</#list>
  params: {}
});

const {
  columns,
  columnChecks,
  data,
  rows,
  getData,
  loading,
  expandedRowKeys,
  isCollapse,
  expandAll,
  collapseAll,
  scrollX
} = useNaiveTreeTable({
  keyField: '${pkColumn.javaField}',
  api: () => fetchGet${BusinessName}List(searchParams.value),
  transform: response => treeTransform(response, { idField: '${pkColumn.javaField}', parentIdField: '${treeParentCode}' }),
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
<#if column.dictType?has_content>
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
        const addBtn = () => {
          return (
            <ButtonIcon
              text
              type="primary"
              icon="material-symbols:add-2-rounded"
              tooltipContent={$t('common.add')}
              onClick={() => addInRow(row)}
            />
          );
        };

        const editBtn = () => {
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

        const buttons = [];
        if (hasAuth('${moduleName}:${businessName}:add')) buttons.push(addBtn());
        if (hasAuth('${moduleName}:${businessName}:edit')) buttons.push(editBtn());
        if (hasAuth('${moduleName}:${businessName}:remove')) buttons.push(deleteBtn());

        return (
          <div class="flex-center gap-8px">
            {buttons.map((btn, index) => (
              <>
                {index !== 0 && <NDivider vertical />}
                {btn}
              </>
            ))}
          </div>
        );
      }
    }
  ]
});

const { drawerVisible, operateType, editingData, handleAdd, handleEdit, checkedRowKeys, onBatchDeleted, onDeleted } =
  useTableOperate(rows, '${pkColumn.javaField}', getData);

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

function addInRow(row: Api.${ModuleName}.${BusinessName}) {
  editingData.value = jsonClone(row);
  handleAdd();
}
<#if enableExport>

function handleExport() {
  download('/${moduleName}/${businessName}/export', searchParams.value, `${functionName}_${r"${new Date().getTime()}"}.xlsx`);
}
</#if>
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <${BusinessName}Search v-model:model="searchParams" @search="getData" />
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
        >
          <template #prefix>
            <NButton v-if="!isCollapse" :disabled="!data.length" size="small" @click="expandAll">
              <template #icon>
                <icon-quill-expand />
              </template>
              全部展开
            </NButton>
            <NButton v-if="isCollapse" :disabled="!data.length" size="small" @click="collapseAll">
              <template #icon>
                <icon-quill-collapse />
              </template>
              全部收起
            </NButton>
          </template>
        </TableHeaderOperation>
      </template>
      <NDataTable
        v-model:checked-row-keys="checkedRowKeys"
        v-model:expanded-row-keys="expandedRowKeys"
        :columns="columns"
        :data="data"
        size="small"
        :flex-height="!appStore.isMobile"
        :scroll-x="scrollX"
        :loading="loading"
        remote
        :row-key="row => row.${pkColumn.javaField}"
        class="sm:h-full"
      />
      <${BusinessName}OperateDrawer
        v-model:visible="drawerVisible"
        :operate-type="operateType"
        :row-data="editingData"
        @submitted="getData"
      />
    </NCard>
  </div>
</template>

<style scoped></style>
