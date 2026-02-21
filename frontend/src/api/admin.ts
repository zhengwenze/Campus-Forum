import request from '@/utils/request'

// 1. 板块相关
export interface BoardRequest {
  name: string
  description?: string
  sort: number
  icon?: string
}

// 添加板块
export function addBoard(data: BoardRequest) {
  return request({
    url: '/admin/board/add',
    method: 'post',
    data
  })
}

// 删除板块
export function deleteBoard(id: number) {
  return request({
    url: `/admin/board/${id}`,
    method: 'delete'
  })
}

// 帖子相关

// 置顶/取消置顶 (接口描述暗示是切换开关，或者是POST动作)
export function toggleTopPost(id: number) {
  return request({
    url: `/admin/post/top/${id}`,
    method: 'post'
  })
}

// 管理员删除帖子
export function deletePostAdmin(id: number) {
  return request({
    url: `/admin/post/${id}`,
    method: 'delete'
  })
}

export interface ModeratorAppointRequest {
    userId: number
    boardId: number
}

export function appointModerator(data: ModeratorAppointRequest) {
    return request({
      url: 'admin/appoint',
      method: 'post',
      data
    })
}

// 用户相关

// 删除用户
export function deleteUser(id: number) {
  return request({
    url: `/admin/user/${id}`,
    method: 'delete'
  })
}