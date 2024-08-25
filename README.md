
---

# Liquor Sales Analysis Project

## Overview

This dbt project is designed to analyze liquor sales data through various transformations and analyses. It leverages dbt for data modeling, transformation, and documentation, with a focus on extracting actionable insights from the sales data.

## Project Structure

```
.
├── LICENSE
├── README.md
├── analyses
├── data
├── dbt_project.yml
├── logs
│   └── dbt.log
├── macros
├── models
│   ├── liquor_sales_analysis.sql
│   ├── schema.yml
│   └── staging
│       ├── schema.yml
│       ├── stg_liquor_sales.sql
│       └── stg_sales.sql
├── requirements.txt
├── structure.txt
├── seeds
├── snapshots
└── tests
```

## Setup

### Prerequisites

- Python 3.7 or higher
- dbt (installed via pip)
- Access to a data warehouse (e.g., Snowflake, BigQuery, Redshift)

### Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/rakesh-singh-byte/Sales-Analytics.git
   cd Sales-Analytics
   ```

2. **Create and Activate a Virtual Environment**

   ```bash
   python -m venv venv
   source venv/bin/activate
   ```

3. **Install Dependencies**

   ```bash
   pip install -r requirements.txt
   ```

4. **Configure dbt**

   Ensure your `profiles.yml` is set up correctly for your data warehouse. Refer to the [dbt documentation](https://docs.getdbt.com/docs/configure-your-profile) for configuration instructions.


## Directory and File Descriptions

- **`README.md`**: Provides an overview of the project, installation instructions, and usage guidelines.

- **`analyses/`**: 
  - **Purpose**: Contains analysis files and queries related to the project’s data.
  - **Contents**: Analysis scripts and related documentation.

- **`data/`**:
  - **Purpose**: Stores data files used in the project.
  - **Contents**: Raw or processed data files.

- **`dbt_project.yml`**:
  - **Purpose**: Configuration file for dbt, defining project settings and directory paths.
  - **Contents**: Project configuration settings.

- **`logs/`**:
  - **Purpose**: Contains log files generated during dbt runs.
  - **Contents**: `dbt.log` for tracking and debugging.

- **`macros/`**:
  - **Purpose**: Holds custom dbt macros for reusable SQL logic.
  - **Contents**: SQL macros used across different models.

- **`models/`**:
  - **Purpose**: Contains dbt models for transforming and analyzing data.
  - **Contents**:
    - **`liquor_sales_analysis.sql`**: Main model for liquor sales analysis.
    - **`schema.yml`**: Defines schema and metadata for models.
    - **`staging/`**: Contains staging models for initial data transformations.
      - **`schema.yml`**: Schema definitions for staging models.
      - **`stg_liquor_sales.sql`**: Staging model for liquor sales data.
      - **`stg_sales.sql`**: Staging model for general sales data.

- **`requirements.txt`**:
  - **Purpose**: Lists Python dependencies required for the project.
  - **Contents**: Python package requirements.

- **`schema.txt`**:
  - **Purpose**: Documentation or configuration related to schema definitions.
  - **Contents**: Details on schema structure.

- **`seeds/`**:
  - **Purpose**: Contains seed data files to be loaded into the data warehouse.
  - **Contents**: CSV files or other data formats for seeding the database.

- **`snapshots/`**:
  - **Purpose**: Contains snapshot files to track historical changes in data.
  - **Contents**: Files used for snapshotting data.

- **`tests/`**:
  - **Purpose**: Directory for dbt tests to validate models and data.
  - **Contents**: Test cases and scripts for data validation.

## Usage Instructions

1. **Install Dependencies**: 
   ```bash
   pip install -r requirements.txt
   ```

## Usage

1. **Run dbt Models**

   Execute dbt models to transform your data:

   ```bash
   dbt run
   ```

2. **Run dbt Tests**

   Validate your data and models with dbt tests:

   ```bash
   dbt test
   ```

3. **Generate and Serve Documentation**

   Create documentation for your dbt models and serve it locally:

   ```bash
   dbt docs generate
   dbt docs serve
   ```

4. **View Logs**

   Access logs in the `logs/` directory. The `dbt.log` file provides details on dbt runs and can be used for troubleshooting.

## Testing

- **Model Tests**: Located in the `tests/` directory, these tests validate the correctness of your dbt models.
- **Data Quality Tests**: Ensure data quality with tests specified in the `tests/` directory.

## Documentation

For detailed information on each model and transformation, refer to the `analyses/` directory and the generated dbt documentation.

## Contributing

1. **Fork the Repository**
2. **Create a Feature Branch**
3. **Commit Your Changes**
4. **Push to the Feature Branch**
5. **Open a Pull Request**

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or support, reach out to [rakesh.s.shankala@gmail.com](mailto:rakesh.s.shankala@gmail.com).

---