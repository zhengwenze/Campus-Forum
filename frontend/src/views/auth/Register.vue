<template>
    <div class="auth-container">
      <el-card class="auth-card">
        <template #header>
          <h2 class="auth-title">注册新账号</h2>
        </template>
        
        <el-form 
          ref="registerFormRef"
          :model="registerForm"
          :rules="rules"
          label-width="0"
          size="large"
        >
          <el-form-item prop="username">
            <el-input 
              v-model="registerForm.username" 
              placeholder="请输入用户名"
              :prefix-icon="User"
            />
          </el-form-item>
          <el-form-item prop="nickname">
            <el-input 
              v-model="registerForm.nickname" 
              placeholder="请输入昵称"
              :prefix-icon="User"
            />
          </el-form-item>
          
          <el-form-item prop="password">
            <el-input 
              v-model="registerForm.password" 
              type="password" 
              placeholder="设置密码"
              :prefix-icon="Lock"
              show-password
            />
          </el-form-item>
  
          <el-form-item prop="confirmPassword">
            <el-input 
              v-model="registerForm.confirmPassword" 
              type="password" 
              placeholder="确认密码"
              :prefix-icon="Lock"
              show-password
            />
          </el-form-item>
  
          <el-form-item>
            <el-button 
              type="primary" 
              class="submit-btn" 
              :loading="loading"
              @click="handleSubmit"
            >
              立即注册
            </el-button>
          </el-form-item>
          
          <div class="auth-footer">
            <span>已有账号？</span>
            <el-link type="primary" @click="$router.push('/login')">去登录</el-link>
          </div>
        </el-form>
      </el-card>
    </div>
  </template>
  
  <script setup>
  import { ref, reactive } from 'vue'
  import { useRouter } from 'vue-router'
  import { register } from '@/api/auth'
  import { User, Lock } from '@element-plus/icons-vue'
  import { ElMessage } from 'element-plus'
  
  const router = useRouter()
  const registerFormRef = ref(null)
  const loading = ref(false)
  
  const registerForm = reactive({
    username: '',
    nickname: '',
    password: '',
    confirmPassword: ''
  })
  
  // 验证确认密码是否一致
  const validatePass2 = (rule, value, callback) => {
    if (value === '') {
      callback(new Error('请再次输入密码'))
    } else if (value !== registerForm.password) {
      callback(new Error('两次输入密码不一致!'))
    } else {
      callback()
    }
  }
  
  const rules = {
    username: [
      { required: true, message: '请输入用户名', trigger: 'blur' },
      { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' }
    ],
    password: [
      { required: true, message: '请输入密码', trigger: 'blur' },
      { min: 6, message: '密码长度不能少于 6 位', trigger: 'blur' }
    ],
    confirmPassword: [
      { required: true, validator: validatePass2, trigger: 'blur' }
    ]
  }
  
  const handleSubmit = async () => {
    if (!registerFormRef.value) return
    
    await registerFormRef.value.validate(async (valid) => {
      if (valid) {
        loading.value = true
        try {
          // 构造后端需要的参数（通常后端只需要 username 和 password）
          const payload = {
            username: registerForm.username,
            password: registerForm.password,
            nickname: registerForm.nickname
          }
          
          await register(payload)
          ElMessage.success('注册成功，请登录')
          router.push('/login')
        } catch (error) {
          console.error(error)
        } finally {
          loading.value = false
        }
      }
    })
  }
  </script>
  
  <style scoped lang="scss">
  /* 复用 Login 的样式，或者在 src/assets/styles/auth.scss 中定义全局样式 */
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