# Database Schema Optimization Session

Used Cursor Agent + Auto mode

## Initial Schema Extension

I tryed the new [GPT 4.1 prompting guide](https://platform.openai.com/docs/guides/gpt/engine) 😄.

### User Request
```markdown
# Role and Objective
You are a sofrware architect with high expertise in Database, SQL, normalization and query optimization.

# Instructions
You must extend current database @schema.prisma with new entities so LTI can operate the entire application flow for different positions.

## Sub-categories for more detailed instructions

# Reasoning Steps
- Think how to extend the current database
- Apply normalization where needed using Boyce-Codd Normal Form (BCNF), for new or existing tables
- Create indexes for query optimizations where needed
- 

# Output Format
You must create a prisma migration file containing the required changes inside @migrations directory.

# Context
- Use this ERD in mermaid to know how to extend the database
"""
erDiagram
     COMPANY {
         int id PK
         string name
     }
     EMPLOYEE {
         int id PK
         int company_id FK
         string name
         string email
         string role
         boolean is_active
     }
     POSITION {
         int id PK
         int company_id FK
         int interview_flow_id FK
         string title
         text description
         string status
         boolean is_visible
         string location
         text job_description
         text requirements
         text responsibilities
         numeric salary_min
         numeric salary_max
         string employment_type
         text benefits
         text company_description
         date application_deadline
         string contact_info
     }
     INTERVIEW_FLOW {
         int id PK
         string description
     }
     INTERVIEW_STEP {
         int id PK
         int interview_flow_id FK
         int interview_type_id FK
         string name
         int order_index
     }
     INTERVIEW_TYPE {
         int id PK
         string name
         text description
     }
     CANDIDATE {
         int id PK
         string firstName
         string lastName
         string email
         string phone
         string address
     }
     APPLICATION {
         int id PK
         int position_id FK
         int candidate_id FK
         date application_date
         string status
         text notes
     }
     INTERVIEW {
         int id PK
         int application_id FK
         int interview_step_id FK
         int employee_id FK
         date interview_date
         string result
         int score
         text notes
     }

     COMPANY ||--o{ EMPLOYEE : employs
     COMPANY ||--o{ POSITION : offers
     POSITION ||--|| INTERVIEW_FLOW : assigns
     INTERVIEW_FLOW ||--o{ INTERVIEW_STEP : contains
     INTERVIEW_STEP ||--|| INTERVIEW_TYPE : uses
     POSITION ||--o{ APPLICATION : receives
     CANDIDATE ||--o{ APPLICATION : submits
     APPLICATION ||--o{ INTERVIEW : has
     INTERVIEW ||--|| INTERVIEW_STEP : consists_of
     EMPLOYEE ||--o{ INTERVIEW : conducts
"""

# Final instructions
- Apply Database best practices
- Ask me if you have any question
```

### Agent Implementation
- Extended schema with new entities: Company, Employee, Position, InterviewFlow, InterviewStep, InterviewType, Application, and Interview
- Added proper relationships and indexes
- Implemented soft delete functionality
- Added migration

### Agent Suggestions
1. We could add composite indexes for frequently queried combinations
2. We could add more specific constraints on certain fields (e.g., status enums)
3. We could add soft delete functionality if needed

## Suggestions application
Proceed with suggested changes step by step

## Soft Delete Discussion

### User Query
"How soft delete is better and worse than a hard delete?"

### Response
#### Soft Delete Advantages 👍
1. **Data Recovery**
   - Accidentally deleted data can be restored
   - No permanent loss of information
   - Helps in disaster recovery scenarios

2. **Data Integrity**
   - Maintains referential integrity in related records
   - Historical relationships remain intact
   - Useful for audit trails and compliance

3. **Business Intelligence**
   - Allows analysis of historical data
   - Can track deletion patterns
   - Useful for metrics like "churn rate" or "deletion reasons"

4. **Legal Compliance**
   - Helps meet data retention requirements
   - Supports legal audit requirements
   - Useful for GDPR's "right to be forgotten" implementation

#### Soft Delete Disadvantages 👎
1. **Database Size**
   - Database grows larger over time
   - Requires periodic archiving strategy
   - Higher storage costs

2. **Query Complexity**
   - Every query needs to include `WHERE isDeleted = false`
   - Risk of forgetting the filter and showing deleted records
   - More complex indexing strategies needed

3. **Performance Impact**
   - Indexes become less efficient with "dead" data
   - More data to scan in queries
   - Potential impact on cache efficiency

4. **Data Privacy**
   - Deleted data still exists in the system
   - May conflict with privacy regulations
   - Requires additional privacy control mechanisms

## Schema Optimization

### Final Changes
1. **Removed Soft Delete from**:
   - `Company` model
   - `Employee` model (keeping `isActive` for status management)

2. **Kept Soft Delete for**:
   - `Position` model (for job posting history)
   - `Application` model (for candidate history)
   - `Interview` model (for process tracking)

### Benefits of Optimized Approach
- Reduces database complexity
- Improves query performance for Company and Employee tables
- Maintains necessary historical data where it's most valuable
- Uses appropriate status flags (`isActive`) instead of soft delete where it makes more sense

## Migration History
1. `20250415215236_add_lti_entities` - Initial schema extension
2. `20250415215642_add_optimizations` - Added composite indexes and enums
3. `20250415220233_optimize_soft_delete` - Optimized soft delete implementation 