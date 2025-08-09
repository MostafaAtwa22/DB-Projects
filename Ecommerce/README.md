# Ecommerce Database System

## Overview
A comprehensive e-commerce database system designed to manage online retail operations. The system handles customer management, product catalogs, order processing, inventory tracking, and staff management with a complete relational database structure.

## Database Structure

### Core Entities
- **Customers**: Customer profiles with contact information and location data
- **Products**: Product catalog with pricing, categories, and brand information
- **Orders**: Order management with status tracking and delivery dates
- **Stores**: Multi-store support with location management
- **Staffs**: Employee management with hierarchical structure
- **Brands**: Product brand management and categorization
- **Categories**: Product categorization system
- **Order_Items**: Detailed order line items with quantities and pricing
- **Stocks**: Inventory management across multiple stores

### Key Features
- ✅ **Multi-Store Support**: Manage multiple store locations
- ✅ **Customer Management**: Comprehensive customer profiles with contact details
- ✅ **Product Catalog**: Organized product hierarchy with brands and categories
- ✅ **Order Processing**: Complete order lifecycle from creation to delivery
- ✅ **Inventory Tracking**: Stock management across different store locations
- ✅ **Staff Management**: Employee hierarchy with manager relationships
- ✅ **Data Integrity**: Extensive foreign key relationships and constraints
- ✅ **Geographic Support**: Multi-city and multi-state customer base

## Files Description

| File | Description |
|------|-------------|
| `Ecommerce.sql` | Complete database schema with tables, constraints, and sample data |
| `Ecommerce.png` | Database diagram visualization (Entity-Relationship Diagram) |
| `README.md` | This documentation file |

## Database Schema

### Tables Overview

#### Customers Table
- **customer_id** (Primary Key)
- **Fname, Lname** - Customer name
- **phone, email** - Contact information (unique constraints)
- **city, state** - Location information

#### Products Table
- **product_id** (Primary Key)
- **product_name** - Product name
- **model_year** - Product year
- **price** - Product pricing
- **brand_id** - Foreign key to Brands table
- **category_id** - Foreign key to Categories table

#### Orders Table
- **order_id** (Primary Key)
- **order_status** - Current order status (Pending, Processing, Shipped, Completed)
- **order_date, required_date, shipped_date** - Order timeline
- **customer_id** - Foreign key to Customers
- **store_id** - Foreign key to Stores
- **staff_id** - Foreign key to Staffs

#### Staffs Table
- **staff_id** (Primary Key)
- **Fname, Lname** - Staff name
- **email, phone** - Contact information
- **store_id** - Assigned store
- **manager_id** - Hierarchical management structure

## Sample Data
The database includes comprehensive sample data:
- **11 Customers** across multiple cities (Cairo, Alexandria, Giza, US cities)
- **20 Orders** with various statuses and dates (March-April 2024)
- **11 Staff Members** with management hierarchy
- **Multiple Stores** for multi-location support
- **Product Catalog** with brands and categories
- **Inventory Records** across different store locations

## Setup Instructions

1. **Prerequisites**: SQL Server Management Studio or compatible SQL client
2. **Database Creation**: Execute the `Ecommerce.sql` script
3. **Verification**: Check that all tables are created with sample data
4. **Testing**: Run sample queries to verify relationships

### Sample Queries

```sql
-- Get all orders for a specific customer
SELECT o.order_id, o.order_status, o.order_date, 
       c.Fname + ' ' + c.Lname AS customer_name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE c.customer_id = 1;

-- Get product information with brand details
SELECT p.product_name, p.price, b.brand_name, cat.category_name
FROM Products p
JOIN Brands b ON p.brand_id = b.brand_id
JOIN Categories cat ON p.category_id = cat.category_id;

-- Get staff hierarchy
SELECT s.Fname + ' ' + s.Lname AS staff_name,
       m.Fname + ' ' + m.Lname AS manager_name,
       st.store_name
FROM Staffs s
LEFT JOIN Staffs m ON s.manager_id = m.staff_id
JOIN Stores st ON s.store_id = st.store_id;
```

## Business Rules
- Each customer must have a unique email and phone number
- Orders can have multiple statuses: Pending, Processing, Shipped, Completed
- Staff members are assigned to specific stores with manager relationships
- Products are categorized by brands and categories
- Inventory is tracked per store location

## Technical Specifications
- **Database Engine**: SQL Server
- **Collation**: Arabic_CI_AS (supports Arabic characters)
- **Character Encoding**: Unicode support for international customers
- **Constraints**: Primary keys, foreign keys, unique constraints
- **Data Types**: Optimized for performance and storage

