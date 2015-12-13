# Use this file to import the sales information into the
# the database.
require "pg"
require "csv"
require "pry"

system 'psql korning < schema.sql'

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

db_connection do |conn|
  @sales = CSV.read('sales.csv', headers: true)

  @sales.map(&:to_hash)
  @sales.each do |sale|
    emp_name = sale["employee"].split[0..1].join(' ')
    emp_email = sale["employee"].split[-1][1..-2]

    check_name = conn.exec("SELECT * FROM employees WHERE name = $1", [emp_name]);
    if check_name.count < 1
      conn.exec_params("INSERT INTO employees (name, email) VALUES ($1, $2)", [emp_name, emp_email]);
    end

    check_frequency = conn.exec("SELECT * FROM frequency WHERE occurrence = $1", [sale["invoice_frequency"]]);
    if check_frequency.count < 1
      conn.exec_params("INSERT INTO frequency (occurrence) VALUES ($1)", [sale["invoice_frequency"]]);
    end

    check_product = conn.exec("SELECT * FROM products WHERE name = $1", [sale["product_name"]]);
    if check_product.count < 1
      conn.exec_params("INSERT INTO products (name) VALUES ($1)", [sale["product_name"]]);
    end

    customer = sale["customer_and_account_no"].split[0..1][0]
    account = sale["customer_and_account_no"].split[-1][1..-2]

    check_accounts = conn.exec("SELECT * FROM accounts WHERE name = $1", [customer]);
    if check_accounts.count < 1
      conn.exec_params("INSERT INTO accounts (name, account_no  ) VALUES ($1, $2)", [customer, account]);
    end


    frequency_id = conn.exec("SELECT id FROM frequency WHERE occurrence = $1", [sale["invoice_frequency"]]);
    frequency_id = frequency_id[0]["id"]

    employee_id = conn.exec("SELECT id FROM employees WHERE name = $1", [emp_name]);
    employee_id = employee_id[0]["id"]

    account_id = conn.exec("SELECT id FROM accounts WHERE name = $1", [customer]);
    account_id  = account_id[0]["id"]

    product_id = conn.exec("SELECT id FROM products WHERE name = $1", [sale["product_name"]]);
    product_id = product_id[0]["id"]


    conn.exec_params("INSERT INTO sales(
    invoice_no,
    sale_date,
    sale_amount,
    units,
    employee_id,
    product_id,
    account_id,
    frequency_id
    )
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)",
    [
      sale["invoice_no"],
      sale["sale_date"],
      sale["sale_amount"],
      sale["units_sold"],
      employee_id,
      product_id,
      account_id,
      frequency_id
     ]
     );

  end
end
