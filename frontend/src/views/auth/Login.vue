<template>
    <div class="auth-container">
      <el-card class="auth-card">
        <template #header>
          <h2 class="auth-title">校园论坛登录</h2>
        </template>
        
        <el-form 
          ref="loginFormRef"
          :model="loginForm"
          :rules="rules"
          label-width="0"
          size="large"
        >
          <el-form-item prop="username">
            <el-input 
              v-model="loginForm.username" 
              placeholder="用户名"
              :prefix-icon="User"
            />
          </el-form-item>
          
          <el-form-item prop="password">
            <el-input 
              v-model="loginForm.password" 
              type="password" 
              placeholder="密码"
              :prefix-icon="Lock"
              show-password
              @keyup.enter="handleSubmit"
            />
          </el-form-item>
  
          <el-form-item>
            <el-button 
              type="primary" 
              class="submit-btn" 
              :loading="loading"
              @click="handleSubmit"
            >
              立即登录
            </el-button>
          </el-form-item>
          
          <div class="auth-footer">
            <span>还没有账号？</span>
            <el-link type="primary" @click="$router.push('/register')">去注册</el-link>
          </div>
        </el-form>
      </el-card>
    </div>
  </template>
  
  <script setup>
  import { ref, reactive } from 'vue'
  import { useRouter } from 'vue-router'
  import { useUserStore } from '@/store/userStore'
  import { User, Lock } from '@element-plus/icons-vue'
  import { ElMessage } from 'element-plus'
  
  const router = useRouter()
  const userStore = useUserStore()
  
  const loginFormRef = ref(null)
  const loading = ref(false)
  
  const loginForm = reactive({
    username: '',
    password: ''
  })
  
  const rules = {
    username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
    password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
  }
  
  const handleSubmit = async () => {
    if (!loginFormRef.value) return
    
    await loginFormRef.value.validate(async (valid) => {
      if (valid) {
        loading.value = true
        try {
          await userStore.handleLogin(loginForm)
          ElMessage.success('登录成功')
          router.push('/') // 跳转到首页
        } catch (error) {
          // 错误已在 request.js 统一处理，这里可以不做处理，或者处理特定的 UI 逻辑
          console.error(error)
        } finally {
          loading.value = false
        }
      }
    })
  }
  </script>
  
  <style scoped lang="scss">
  .auth-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background-color: #f0f2f5;
    
    .auth-card {
      width: 400px;
      
      .auth-title {
        text-align: center;
        margin: 0;
        color: #303133;
      }
      
      .submit-btn {
        width: 100%;
      }
      
      .auth-footer {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        color: #606266;
      }
    }
  }
  </style>