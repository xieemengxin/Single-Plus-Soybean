<script setup lang="ts">
import { computed, ref } from 'vue';
import { useAuthStore } from '@/store/modules/auth';
import { useRouterPush } from '@/hooks/common/router';
import { $t } from '@/locales';

defineOptions({
  name: 'Totp'
});

const authStore = useAuthStore();
const { toggleLoginModule } = useRouterPush();

const code = ref<string>('');

const totpInfo = computed(() => authStore.totpInfo);

// 无两步验证会话（例如直接访问 /login/totp 或会话已消费）时回到密码登录
if (!authStore.totpInfo) {
  toggleLoginModule('pwd-login');
}

async function handleSubmit() {
  if (!code.value) {
    window.$message?.warning($t('page.login.totp.codePlaceholder'));
    return;
  }
  try {
    await authStore.totpLogin(code.value);
  } catch {
    // 口令错误时清空输入重新填写；会话过期由后端提示，用户可返回重新登录
    code.value = '';
  }
}

function handleBack() {
  authStore.totpInfo = null;
  toggleLoginModule('pwd-login');
}
</script>

<template>
  <div>
    <div class="mb-5px text-32px text-black font-600 dark:text-white">{{ $t('page.login.totp.title') }}</div>
    <div class="pb-18px text-16px text-#858585">
      {{ totpInfo?.bind ? $t('page.login.totp.bindTip') : $t('page.login.totp.verifyTip') }}
    </div>

    <div v-if="totpInfo?.bind && totpInfo?.qrUrl" class="flex-col-center gap-12px pb-18px">
      <NQrCode :value="totpInfo.qrUrl" :size="180" class="rounded-8px bg-white" />
      <div class="text-14px text-#858585">
        {{ $t('page.login.totp.manualKey') }}
        <NText code class="break-all">{{ totpInfo.secret }}</NText>
      </div>
    </div>

    <NForm size="large" :show-label="false" @keyup.enter="() => !authStore.loginLoading && handleSubmit()">
      <NFormItem>
        <NInput
          v-model:value="code"
          :maxlength="6"
          :placeholder="$t('page.login.totp.codePlaceholder')"
          :input-props="{ autocomplete: 'one-time-code', inputmode: 'numeric' }"
        />
      </NFormItem>
      <NSpace vertical :size="12">
        <NButton type="primary" size="large" block :loading="authStore.loginLoading" @click="handleSubmit">
          {{ $t('page.login.totp.verify') }}
        </NButton>
        <NButton size="large" block quaternary @click="handleBack">
          {{ $t('page.login.totp.backToLogin') }}
        </NButton>
      </NSpace>
    </NForm>
  </div>
</template>

<style scoped>
:deep(.n-input) {
  --n-height: 42px !important;
  --n-font-size: 16px !important;
  --n-border-radius: 8px !important;
}

:deep(.n-button) {
  --n-height: 42px !important;
  --n-font-size: 18px !important;
  --n-border-radius: 8px !important;
}
</style>
