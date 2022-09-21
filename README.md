# demo-lz-docs

This is the documentation repo for Landing Zone Docs Demo.  Here you will find:

- Content for the portal site itself
- Instructions on how to modify the content
- An overview of the CI/CD pipeline that builds the site

## Repo Structure

```
.
├── app/                         - The template for the Google App Engine Python web applicaton
├── content/                     - Where the portal content lives. THIS IS WHAT YOU UPDATE
├── src/                         - Hugo configuration and themes
├── themes/                      - In case we want to build using GitLab Hugo project
├── .github/workflows/pages.yml  - The GitHub Action CI/CD pipeline configuration
├── .gitlab-ci.yml               - The GitLab CI/CD pipeline configuration
├── README.md                    - This file
├── functions.sh                 - Bash helper functions, used by the pipeline
├── local.Dockerfile             - Hugo container image, for local site development
└── local.docker-compose.yml     - To facilitate building and launching the local Hugo container
```

## Site Content

The site is primarily composed of markdown (.md) files which are converted to HTML during the build step for the site. The rendering of the markdown to HTML is achieved using [Hugo](https://gohugo.io/).  

All site content sits under the `content` folder. Adding sub-folders under the `contents` folder will create sub-sections.  These each require an `_index.md` file for their landing page (see existing examples for inspiration). Other `.md` files in subfolders will exist as pages within the subsection. The entire content structure is therefore made up logically of folders and `.md` files.

It's recommended to look at the existing content folder and its contents and compare this to the live site for an easy understanding of how to structure your content.

## Site Hosting

The static site generated by the CI/CD pipeline and can be hosted in various locations, e.g.
- Using GitHub Pages.
- As a Google App Engine service. See [here](https://cloud.google.com/appengine/docs/standard/python/getting-started/hosting-a-static-website) for an overview of how it works.

## Updating the site

To update the site, make changes to content in _this_ repo.  When you're happy with your changes, commit them, and create a merge request for your commit.  Once your merge has been accepted into the main branch, it will be deployed to App Engine automatically.  This deployment takes a couple of minutes to run.

## GCP Project information

The AppEngine version of the site is hosted within the _demo-lz-docs tbc_ project in GCP.

## Pipeline

The pipeline currently has two steps: Build and Deploy. 
  - The _Build_ step renders the website from the source, and outputs the resultant site to an artifact for the next step. 
  - The _Deploy_ step deploys an App Engine application, which points to the site content created in the _Build_ step.

## Developing the Site Locally

If you are planning on making **frequent or substantial changes to this site**, it will be preferable to download this repo, and to make your changes locally before pushing back to this repo.  Why?  Because testing changes using the repo-hosted CI/CD process takes a couple of minutes.  This can be a painful delay if you're making a lot of changes. Whereas changes made locally will be visible to you instantly.

There are a couple of ways to run this site locally.

1. You can install Hugo on your machine.
1. You can run Hugo as a container.

Personally, I prefer the container approach, because we can use the Docker Compose in this repo to run a container with the same version of Hugo that the CI/CD runner uses.

Below are instructions for how to run Huge in a container locally, in order to render the site on localhost.

### Pre-Reqs

On your machine you will need:

- Docker. 
  - E.g. by installing Docker Desktop or Rancher Desktop. (On Windows, both of these require WSL.)
- Git.
  - If running this on a corporate device behind the proxy, you'll may need to set proxy configuration for git: \
    git config --global http.proxy http://whatever-proxy:80
- Access to this repo.

### Steps

- Clone demo-lz-docs to your machine.
- Run the Docker compose, which will build and run the Hugo image from the local.Dockerfile: \
  `docker compose -f ./local.docker-compose.yml up`
- You will see Hugo start up, and the console will show the localhost URL for your site.

If you want to interactively work with the container (e.g. for debugging): \
`docker run --rm -it --entrypoint /bin/sh -v $(pwd):/src -p 1313:1313 hugo-engine:0.1`
