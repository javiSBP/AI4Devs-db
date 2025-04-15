/*
  Warnings:

  - The `status` column on the `Application` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `result` column on the `Interview` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `status` column on the `Position` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- CreateEnum
CREATE TYPE "PositionStatus" AS ENUM ('DRAFT', 'PUBLISHED', 'CLOSED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "ApplicationStatus" AS ENUM ('PENDING', 'REVIEWING', 'SHORTLISTED', 'INTERVIEWING', 'OFFERED', 'HIRED', 'REJECTED', 'WITHDRAWN');

-- CreateEnum
CREATE TYPE "InterviewResult" AS ENUM ('PENDING', 'PASSED', 'FAILED', 'NEEDS_FURTHER_REVIEW');

-- DropIndex
DROP INDEX "Application_candidateId_idx";

-- DropIndex
DROP INDEX "Application_positionId_idx";

-- DropIndex
DROP INDEX "Interview_applicationId_idx";

-- DropIndex
DROP INDEX "Interview_employeeId_idx";

-- DropIndex
DROP INDEX "Interview_interviewStepId_idx";

-- DropIndex
DROP INDEX "Position_companyId_idx";

-- AlterTable
ALTER TABLE "Application" ADD COLUMN     "deletedAt" TIMESTAMP(3),
ADD COLUMN     "isDeleted" BOOLEAN NOT NULL DEFAULT false,
DROP COLUMN "status",
ADD COLUMN     "status" "ApplicationStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "Company" ADD COLUMN     "deletedAt" TIMESTAMP(3),
ADD COLUMN     "isDeleted" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "Employee" ADD COLUMN     "deletedAt" TIMESTAMP(3),
ADD COLUMN     "isDeleted" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "Interview" ADD COLUMN     "deletedAt" TIMESTAMP(3),
ADD COLUMN     "isDeleted" BOOLEAN NOT NULL DEFAULT false,
DROP COLUMN "result",
ADD COLUMN     "result" "InterviewResult" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "Position" ADD COLUMN     "deletedAt" TIMESTAMP(3),
ADD COLUMN     "isDeleted" BOOLEAN NOT NULL DEFAULT false,
DROP COLUMN "status",
ADD COLUMN     "status" "PositionStatus" NOT NULL DEFAULT 'DRAFT';

-- CreateIndex
CREATE INDEX "Application_positionId_status_idx" ON "Application"("positionId", "status");

-- CreateIndex
CREATE INDEX "Application_candidateId_status_idx" ON "Application"("candidateId", "status");

-- CreateIndex
CREATE INDEX "Application_positionId_applicationDate_idx" ON "Application"("positionId", "applicationDate");

-- CreateIndex
CREATE INDEX "Interview_applicationId_interviewDate_idx" ON "Interview"("applicationId", "interviewDate");

-- CreateIndex
CREATE INDEX "Interview_employeeId_interviewDate_idx" ON "Interview"("employeeId", "interviewDate");

-- CreateIndex
CREATE INDEX "Interview_interviewStepId_result_idx" ON "Interview"("interviewStepId", "result");

-- CreateIndex
CREATE INDEX "Position_companyId_status_idx" ON "Position"("companyId", "status");

-- CreateIndex
CREATE INDEX "Position_companyId_isVisible_idx" ON "Position"("companyId", "isVisible");
