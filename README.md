# Harvest Dashboard 

Rails app able to integrate information between harvestapp accounts.

Sample app https://guarded-mountain-49893.herokuapp.com/

Features:

    * Manage multiple accounts
    * Validates Organization credentials
    * Merge accounts and present a report
    * Report could be grouped and filtered by Date, Staff, Task, and Organization.

## Instalation

    * Clone the repo
    * cd harvest_dashboard
    * bundle install
    * rails db:setup (update credentials as needed)
    * rails server
    * access on your browser: localhost:3000

## Use

In order to get reports, you will need to add organizations on the app.(link at the top)

## Assets

    * Javascript libraries loaded by CDN:

        * JQuery
        * DataTables
        * Bootstrap

## Recommendations

    * Hide account password
    * Add authentication system
    * Add local assets
    * Add turbolinks, and load datatables src by ajax calls.

Developed by Ruben Amortegui - 2017
