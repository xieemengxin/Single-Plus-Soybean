<#-- soybean 前端搜索组件模板：输出 views/{模块}/{业务}/modules/{业务}-search.vue -->
<script setup lang="ts">
<#if needDateRange>
import { ref, toRaw } from 'vue';
<#else>
import { toRaw } from 'vue';
</#if>
import { jsonClone } from '@sa/utils';
import { useNaiveForm } from '@/hooks/common/form';
import { $t } from '@/locales';

defineOptions({
  name: '${BusinessName}Search'
});

interface Emits {
  (e: 'search'): void;
}

const emit = defineEmits<Emits>();

const { formRef, validate, restoreValidation } = useNaiveForm();

const model = defineModel<Api.${ModuleName}.${BusinessName}SearchParams>('model', { required: true });
<#list columns as column>
<#if column.dateRangeQuery>

const dateRange${column.capJavaField} = ref<[string, string] | null>(null);
</#if>
</#list>

const defaultModel = jsonClone(toRaw(model.value));
<#list columns as column>
<#if column.dateRangeQuery>

function onDateRange${column.capJavaField}Update(value: [string, string] | null) {
  model.value.params = {
    ...model.value.params,
    begin${column.capJavaField}: value?.[0],
    end${column.capJavaField}: value?.[1]
  };
}
</#if>
</#list>

function resetModel() {
<#list columns as column>
<#if column.dateRangeQuery>
  dateRange${column.capJavaField}.value = null;
</#if>
</#list>
  Object.assign(model.value, defaultModel);
}

async function reset() {
  await restoreValidation();
  resetModel();
  emit('search');
}

async function search() {
  await validate();
  emit('search');
}
</script>

<template>
  <NCard :bordered="false" size="small" class="card-wrapper">
    <NCollapse>
      <NCollapseItem :title="$t('common.search')" name="${moduleKebab}-${businessKebab}-search">
        <NForm ref="formRef" :model="model" label-placement="left" :label-width="80">
          <NGrid responsive="screen" item-responsive>
<#assign immediateDicts = []>
<#list columns as column>
<#if column.query>
            <NFormItemGi span="24 s:12 m:6" label="${column.columnLabel}" path="${column.javaField}" class="pr-24px">
<#if ['select', 'radio', 'checkbox', 'switch']?seq_contains(column.htmlType!'') && column.dictType?has_content>
              <DictSelect
                v-model:value="model.${column.javaField}"
                placeholder="请选择${column.columnLabel}"
                dict-code="${column.dictType}"
                clearable
<#if !column.list && !immediateDicts?seq_contains(column.dictType)>
<#assign immediateDicts = immediateDicts + [column.dictType]>
                immediate
</#if>
              />
<#elseif ['select', 'radio', 'checkbox', 'switch']?seq_contains(column.htmlType!'')>
              <NSelect
                v-model:value="model.${column.javaField}"
                placeholder="请选择${column.columnLabel}"
                :options="[]"
                clearable
              />
<#elseif column.htmlType == 'datetime' && (column.queryType!'') == 'BETWEEN'>
              <NDatePicker
                v-model:formatted-value="dateRange${column.capJavaField}"
                type="datetimerange"
                value-format="yyyy-MM-dd HH:mm:ss"
                clearable
                :default-time="['00:00:00', '23:59:59']"
                @update:formatted-value="onDateRange${column.capJavaField}Update"
              />
<#elseif column.htmlType == 'datetime'>
              <NDatePicker
                v-model:formatted-value="model.${column.javaField}"
                type="datetime"
                value-format="yyyy-MM-dd HH:mm:ss"
                clearable
              />
<#elseif column.htmlType == 'inputNumber'>
              <NInputNumber v-model:value="model.${column.javaField}" placeholder="请输入${column.columnLabel}" clearable class="w-full" />
<#else>
              <NInput v-model:value="model.${column.javaField}" placeholder="请输入${column.columnLabel}" />
</#if>
            </NFormItemGi>
</#if>
</#list>
            <NFormItemGi :show-feedback="false" span="24" class="pr-24px">
              <NSpace class="w-full" justify="end">
                <NButton @click="reset">
                  <template #icon>
                    <icon-ic-round-refresh class="text-icon" />
                  </template>
                  {{ $t('common.reset') }}
                </NButton>
                <NButton type="primary" ghost @click="search">
                  <template #icon>
                    <icon-ic-round-search class="text-icon" />
                  </template>
                  {{ $t('common.search') }}
                </NButton>
              </NSpace>
            </NFormItemGi>
          </NGrid>
        </NForm>
      </NCollapseItem>
    </NCollapse>
  </NCard>
</template>

<style scoped></style>
