package com.ljx.forum.mapper;

import com.ljx.forum.entity.Post;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 * 帖子表 Mapper 接口
 * </p>
 *
 * @author ljx
 * @since 2025-11-21
 */
@Mapper
public interface PostMapper extends BaseMapper<Post> {

}
