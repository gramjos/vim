### Strategy
Copy the `.vim/` directory and the `.vimrc` file into the newly cloned `gramjos/vim`. Overwriting the old files.
```shell
$ git clone https://github.com/gramjos/vim.git
$ cd vim/
$ cp -r ../.vim/* ../.vimrc .
```
Then commit to GitHub

TODO: 
*   [ ] change the sync command to the `rclone` rather than `cp`
