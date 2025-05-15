# DevOps Technical Assessment
Welcome to our DevOps technical assessment. This challenge is designed to evaluate your proficiency in setting up Continuous Integration/Continuous Deployment (CI/CD) pipelines, managing server deployments, and ensuring application reliability and security.

### Objective
You will work with an existing Ruby on Rails application. Your tasks include:

1. CI/CD Pipeline Setup: Configure a CI/CD pipeline using a tool of your choice (e.g., GitHub Actions, CircleCI, Jenkins). The pipeline should:

    - Run tests on every pull request.
    - Prevent merging into the main branch if tests fail.

2. Automated Deployment: Implement an automated deployment process that:

    - Deploys the application to a remote server upon successful merge into the main branch.

    - Ensures the application is accessible publicly.

3. Server Provisioning and Deployment:

    - Provision a Virtual Private Server (VPS) on a provider like Hetzner, DigitalOcean, or Linode. (We will give you access to our Hetzner account)

    - Deploy the Rails application using Docker.

    - Ensure the application is secure and follows best practices.

### Guidelines
- *Flexibility*: Use any tools or methodologies you're comfortable with. While we use GitHub Actions internally, feel free to choose tools that showcase your strengths.

- *Documentation*: Document your process, decisions, and any assumptions made. This helps us understand your thought process.

- *Security*: Emphasize security best practices in your deployment.

- *Automation*: Aim for automation wherever possible to reduce manual intervention.

### Technical Details
- *Docker:* A Dockerfile is present in the root directory of the Rails application. Use this for containerizing the application.

- *Database:* The application requires PostgreSQL. You're responsible for setting it up on the VPS. Consider using Docker Compose or Kamal, or anything that makes it easy for you to setup the database on the VPS.

### Environment Variables:

- Set SOLID_QUEUE_IN_PUMA=1 to run background jobs within the Puma server.
- Set DEVOPS_DATABASE_PASSWORD to the password you setup for the postgres database

### Database Configuration:

The application uses multiple databases in production. Ensure the following databases are created and configured:

```
production:
  primary: &primary_production
    <<: *default
    database: devops_production
    username: devops
    password: <%= ENV["DEVOPS_DATABASE_PASSWORD"] %>
  cache:
    <<: *primary_production
    database: devops_production_cache
    migrations_paths: db/cache_migrate
  queue:
    <<: *primary_production
    database: devops_production_queue
    migrations_paths: db/queue_migrate
  cable:
    <<: *primary_production
    database: devops_production_cable
    migrations_paths: db/cable_migrate
```


### Evaluation Criteria
Your submission will be assessed based on:

- *CI/CD Implementation:* Effectiveness and reliability of the pipeline.

- *Automation:* Degree of automation in deployment and server setup.

- *Security:* Implementation of security best practices.

- *Documentation:* Clarity and thoroughness of documentation.

- *Problem-Solving:* Ability to handle challenges and justify decisions.

## Submission
Please provide:

- Access to the repository with your CI/CD configurations.

- Documentation detailing your setup, decisions, and any challenges faced.

- Access details to the deployed application (URL, credentials if necessary).

### Additional Resources
For guidance and best practices, consider the following resources:

- [Building a Rails CI pipeline with GitHub Actions](https://boringrails.com/articles/building-a-rails-ci-pipeline-with-github-actions/)

- [Deploying a Rails app with Kamal](https://medium.com/@huseyinbiyik/deploying-a-rails-app-with-kamal-c0aeb91f3868)

- [Kamal website](https://kamal-deploy.org)

Feel free to reach out if you have any questions or need further clarification