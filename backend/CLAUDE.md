# Project Context: Campus Forum Backend (MVP)
This is the backend for a Campus Forum application.
Goal: Build a functional MVP in 7 days.
Language: Chinese (Comments & JavaDoc).

## 1. Tech Stack
- **Language**: Java 21 (Strictly use JDK 21 features).
- **Framework**: Spring Boot 3.2+.
- **ORM**: MyBatis-Plus (MP).
- **Database**: MySQL 8.0.
- **Cache**: Redis (Spring Data Redis).
- **Security**: Spring Security + JWT (Stateless).
- **Docs**: Knife4j (Swagger).
- **Utils**: Hutool (optional), Lombok.

## 2. Architecture & Package Structure
Root Package: `com.ljx.forum`
- `common`: Global configs, Exception handlers, Unified Result wrapper (`Result.java`).
- `config`: Configuration classes (SecurityConfig, WebMvcConfig, etc.).
- `controller`: REST controllers (Web Layer).
- `service`: Service Interfaces.
    - `impl`: Service Implementations.
- `mapper`: MyBatis Mappers (Data Layer).
- `entity`: DB Entities (Matches MySQL tables 1:1).
- `dto`: Data Transfer Objects (Input parameters). **Use Java Records**.
- `vo`: View Objects (Output responses).
- `security`: JWT filters, UserDetailService implementation.

## 3. Coding Standards & Guidelines

### 3.1 Java 21 Features
- **Records**: Use `record` for all DTOs and immutable VOs.
    - Example: `public record LoginRequest(String username, String password) {}`
- **Var**: Use `var` for local variable type inference to keep code clean.
- **Switch Expressions**: Use modern switch syntax where applicable.

### 3.2 Controller Layer
- **Unified Response**: All controllers MUST return `Result<T>`.
    - Success: `Result.success(data)`
    - Error: `Result.error(code, msg)`
- **RESTful**: Use `@GetMapping`, `@PostMapping`, etc.
- **Validation**: Use `@Valid` / `@RequestBody` for input DTOs.

### 3.3 Service & Database Layer
- **MyBatis-Plus**:
    - Extend `IService<T>` for Services and `BaseMapper<T>` for Mappers.
    - **Avoid XML**: Use `LambdaQueryWrapper` and `LambdaUpdateWrapper` for 95% of SQL operations. Only write custom XML for complex joins.
- **Transactional**: Add `@Transactional` to service methods involving data modification.

### 3.4 Security & Auth
- **Stateless**: Disable Session (`SessionCreationPolicy.STATELESS`).
- **JWT**:
    - Token contains `userId` and `role`.
    - Store `userId` in `SecurityContextHolder`.
    - Helper class `SecurityUtils.getUserId()` to retrieve current user.

## 4. Development Workflow
1. **Entity First**: When implementing a feature, define the `Entity` (and DB table) first.
2. **Generator**: Use MyBatis-Plus logic to generate basic CRUD.
3. **Logic**: Implement Business Logic in ServiceImpl, NOT in Controller.
4. **Exceptions**: Throw custom `BusinessException` for logic errors (e.g., "User not found"), let GlobalExceptionHandler handle the HTTP response.

## 5. Specific Directives for Claude
- When generating code, include **Chinese comments** for complex logic.
- If I ask for a feature (e.g., "Post Creation"), provide the full stack: Entity -> Mapper -> Service -> Controller.
- Assume `Lombok` is available (`@Data`, `@Slf4j`, `@Builder`).

## 6. 注释规范
1. 必须使用中文注释

## 7. 不要生成文档说明，写代码前先给我一个方案，我确认方案了才开始实现

## 8. 回答我的问题必须使用中文