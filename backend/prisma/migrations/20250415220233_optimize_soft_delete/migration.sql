/*
  Warnings:

  - You are about to drop the column `deletedAt` on the `Company` table. All the data in the column will be lost.
  - You are about to drop the column `isDeleted` on the `Company` table. All the data in the column will be lost.
  - You are about to drop the column `deletedAt` on the `Employee` table. All the data in the column will be lost.
  - You are about to drop the column `isDeleted` on the `Employee` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Company" DROP COLUMN "deletedAt",
DROP COLUMN "isDeleted";

-- AlterTable
ALTER TABLE "Employee" DROP COLUMN "deletedAt",
DROP COLUMN "isDeleted";
