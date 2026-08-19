<script setup lang="ts" generic="T extends string = Api.Common.EnableStatus">
import { useBoolean } from '@sa/hooks';
import { enableStatusRecord } from '@/constants/business';

defineOptions({
  name: 'StatusSwitch'
});

interface Props {
  disabled?: boolean;
  info?: string;
  /** 开启状态对应的值，默认 '0'（启用） */
  checkedValue?: T;
  /** 关闭状态对应的值，默认 '1'（停用） */
  uncheckedValue?: T;
  /** 确认弹窗文案，按值取文案，默认使用启用/停用 */
  actionText?: Record<string, string>;
}

const props = withDefaults(defineProps<Props>(), {
  disabled: false,
  info: '',
  checkedValue: '0' as never,
  uncheckedValue: '1' as never,
  actionText: undefined
});

const value = defineModel<T>('value', { default: '0' as never });

interface Emits {
  (e: 'submitted', value: T, callback: (flag: boolean) => void): void;
}

const emit = defineEmits<Emits>();

/** 状态切换过程的 loading 状态 */
const { bool: loading, setTrue: startLoading, setFalse: endLoading } = useBoolean();

const getActionText = (val: T) => {
  if (props.actionText) return props.actionText[val] || '';
  return enableStatusRecord[val as Api.Common.EnableStatus];
};

const handleUpdateValue = (val: T) => {
  const checked = (props.checkedValue ?? '0') as T;
  const unchecked = (props.uncheckedValue ?? '1') as T;
  value.value = val === checked ? unchecked : checked;
  window.$dialog?.warning({
    title: '系统提示',
    content: `确定要${getActionText(val)} ${props.info} 吗？`,
    positiveText: '确定',
    negativeText: '取消',
    onPositiveClick: () => {
      startLoading();
      emit('submitted', val, flag => {
        if (flag) value.value = val;
        endLoading();
      });
    },
    onNegativeClick: () => {}
  });
};
</script>

<template>
  <NSwitch
    v-model:value="value"
    :loading="loading"
    :rubber-band="false"
    :checked-value="props.checkedValue"
    :unchecked-value="props.uncheckedValue"
    :disabled="props.disabled"
    @update:value="handleUpdateValue"
  />
</template>

<style scoped></style>
