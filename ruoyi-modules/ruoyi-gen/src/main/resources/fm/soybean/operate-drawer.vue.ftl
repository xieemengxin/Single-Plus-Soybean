<#-- soybean 前端新增/编辑抽屉模板：输出 views/{模块}/{业务}/modules/{业务}-operate-drawer.vue -->
<#assign operateColumns = columns?filter(c -> c.insert || c.edit)>
<#assign insertColumns = columns?filter(c -> c.insert)>
<#assign editColumns = columns?filter(c -> c.edit)>
<#assign requiredColumns = operateColumns?filter(c -> c.required)>
<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { jsonClone } from '@sa/utils';
import { fetchCreate${BusinessName}, fetchUpdate${BusinessName}<#if table.tree>, fetchGet${BusinessName}List</#if> } from '@/service/api/${moduleKebab}/${businessKebab}';
import { useFormRules, useNaiveForm } from '@/hooks/common/form';
<#if table.tree>
import { handleTree } from '@/utils/common';
</#if>
import { $t } from '@/locales';

defineOptions({
  name: '${BusinessName}OperateDrawer'
});

interface Props {
  /** the type of operation */
  operateType: NaiveUI.TableOperateType;
  /** the edit row data */
  rowData?: Api.${ModuleName}.${BusinessName} | null;
}

const props = defineProps<Props>();

interface Emits {
  (e: 'submitted'): void;
}

const emit = defineEmits<Emits>();

const visible = defineModel<boolean>('visible', {
  default: false
});
<#if table.tree>

const treeList = ref<Api.${ModuleName}.${BusinessName}[]>([]);
</#if>

const { formRef, validate, restoreValidation } = useNaiveForm();
const { createRequiredRule } = useFormRules();

const title = computed(() => {
  const titles: Record<NaiveUI.TableOperateType, string> = {
    add: '新增${functionName}',
    edit: '编辑${functionName}'
  };
  return titles[props.operateType];
});

type Model = Api.${ModuleName}.${BusinessName}OperateParams;

const model = ref<Model>(createDefaultModel());

function createDefaultModel(): Model {
  return {
<#list operateColumns as column>
    ${column.javaField}: <#if (column.javaType!'') == 'String' || column.dictType?has_content>''<#else>null</#if><#sep>,</#sep>
</#list>
  };
}

<#if requiredColumns?has_content>
type RuleKey = Extract<keyof Model, <#list requiredColumns as column>'${column.javaField}'<#sep> | </#sep></#list>>;

const rules: Record<RuleKey, App.Global.FormRule> = {
<#list requiredColumns as column>
  ${column.javaField}: createRequiredRule('${column.columnLabel}不能为空')<#sep>,</#sep>
</#list>
};
<#else>
type RuleKey = never;

const rules: Record<RuleKey, App.Global.FormRule> = {};
</#if>

function handleUpdateModelWhenEdit() {
  model.value = createDefaultModel();
<#if table.tree>
  model.value.${treeParentCode} = props.rowData?.${treeCode} || 0;
</#if>

  if (props.operateType === 'edit' && props.rowData) {
    Object.assign(model.value, jsonClone(props.rowData));
  }
}

function closeDrawer() {
  visible.value = false;
}

async function handleSubmit() {
  await validate();

  const { <#list operateColumns as column>${column.javaField}<#sep>, </#sep></#list> } = model.value;

  // request
  if (props.operateType === 'add') {
    const { error } = await fetchCreate${BusinessName}({ <#list insertColumns as column>${column.javaField}<#sep>, </#sep></#list> });
    if (error) return;
    window.$message?.success($t('common.addSuccess'));
  }

  if (props.operateType === 'edit') {
    const { error } = await fetchUpdate${BusinessName}({ <#list editColumns as column>${column.javaField}<#sep>, </#sep></#list> });
    if (error) return;
    window.$message?.success($t('common.updateSuccess'));
  }

  closeDrawer();
  emit('submitted');
}
<#if table.tree>

async function getTreeList() {
  const { data, error } = await fetchGet${BusinessName}List();
  if (error) {
    return;
  }
  const { tree } = handleTree(data, { idField: '${treeCode}', parentIdField: '${treeParentCode}' });
  treeList.value = tree;
}
</#if>

watch(visible, () => {
  if (visible.value) {
    handleUpdateModelWhenEdit();
    restoreValidation();
<#if table.tree>
    getTreeList();
</#if>
  }
});
<#if table.tree>

const treeOptions = computed(() => {
  return [
    {
      ${treeCode}: 0,
      ${treeName}: '顶级节点',
      children: treeList.value
    }
  ];
});
</#if>
</script>

<template>
  <NDrawer v-model:show="visible" :title="title" display-directive="show" :width="800" class="max-w-90%">
    <NDrawerContent :title="title" :native-scrollbar="false" closable>
      <NForm ref="formRef" :model="model" :rules="rules">
<#assign immediateDicts = []>
<#list columns as column>
<#if (column.insert || column.edit) && !column.pk>
<#-- 字典是否需要由当前组件立即加载：列表列与查询列已由列表页/搜索组件加载，且同一字典只加载一次 -->
<#assign needImmediate = column.dictType?has_content && !column.list && !column.query && !immediateDicts?seq_contains(column.dictType!'')>
        <NFormItem label="${column.columnLabel}" path="${column.javaField}">
<#if table.tree && column.javaField == treeParentCode>
          <NTreeSelect
            v-model:value="model.${treeParentCode}"
            filterable
            class="h-full"
            key-field="${treeCode}"
            label-field="${treeName}"
            :options="treeOptions"
            :default-expanded-keys="[0]"
          />
<#elseif column.htmlType == 'textarea'>
          <NInput
            v-model:value="model.${column.javaField}"
            :rows="3"
            type="textarea"
            placeholder="请输入${column.columnLabel}"
          />
<#elseif column.htmlType == 'editor'>
          <WangEditor v-model:value="model.${column.javaField}" />
<#elseif column.htmlType == 'select' && column.dictType?has_content>
          <DictSelect
            v-model:value="model.${column.javaField}"
            placeholder="请选择${column.columnLabel}"
            dict-code="${column.dictType}"
            clearable
<#if needImmediate>
<#assign immediateDicts = immediateDicts + [column.dictType]>
            immediate
</#if>
          />
<#elseif column.htmlType == 'select'>
          <NSelect
            v-model:value="model.${column.javaField}"
            placeholder="请选择${column.columnLabel}"
            :options="[{ value: '0', label: '请选择字典生成' }]"
            clearable
          />
<#elseif (column.htmlType == 'radio' || column.htmlType == 'switch') && column.dictType?has_content>
          <DictRadio
            v-model:value="model.${column.javaField}"
            dict-code="${column.dictType}"
<#if needImmediate>
<#assign immediateDicts = immediateDicts + [column.dictType]>
            immediate
</#if>
          />
<#elseif column.htmlType == 'radio'>
          <NRadioGroup v-model:value="model.${column.javaField}">
            <NSpace>
              <NRadio value="0" label="请选择字典生成" />
            </NSpace>
          </NRadioGroup>
<#elseif column.htmlType == 'switch'>
          <NSwitch
            v-model:value="model.${column.javaField}"
            :checked-value="${column.switchActiveValue}"
            :unchecked-value="${column.switchInactiveValue}"
          />
<#elseif column.htmlType == 'checkbox' && column.dictType?has_content>
          <DictCheckbox
            v-model:value="model.${column.javaField}"
            dict-code="${column.dictType}"
<#if needImmediate>
<#assign immediateDicts = immediateDicts + [column.dictType]>
            immediate
</#if>
          />
<#elseif column.htmlType == 'checkbox'>
          <NCheckboxGroup v-model:value="model.${column.javaField}">
            <NSpace>
              <NCheckbox value="0" label="请选择字典生成" />
            </NSpace>
          </NCheckboxGroup>
<#elseif column.htmlType == 'datetime'>
          <NDatePicker
            v-model:formatted-value="model.${column.javaField}"
            type="datetime"
            value-format="yyyy-MM-dd HH:mm:ss"
            clearable
          />
<#elseif column.htmlType == 'imageUpload'>
          <OssUpload v-model:value="model.${column.javaField}" upload-type="image" />
<#elseif column.htmlType == 'fileUpload'>
          <OssUpload v-model:value="model.${column.javaField}" upload-type="file" />
<#elseif column.htmlType == 'inputNumber'>
          <NInputNumber v-model:value="model.${column.javaField}" placeholder="请输入${column.columnLabel}" clearable class="w-full" />
<#else>
          <NInput v-model:value="model.${column.javaField}" placeholder="请输入${column.columnLabel}" />
</#if>
        </NFormItem>
</#if>
</#list>
      </NForm>
      <template #footer>
        <NSpace :size="16">
          <NButton @click="closeDrawer">{{ $t('common.cancel') }}</NButton>
          <NButton type="primary" @click="handleSubmit">{{ $t('common.confirm') }}</NButton>
        </NSpace>
      </template>
    </NDrawerContent>
  </NDrawer>
</template>

<style scoped></style>
