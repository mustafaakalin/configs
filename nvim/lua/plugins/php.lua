return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "php" } },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "phpcs",
        "php-cs-fixer",
      },
    },
  },
  {
    "V13Axel/neotest-pest",
    "olimorris/neotest-phpunit",
  },
  "olimorris/neotest-phpunit",
  {
    "neotest-pest",
    ["neotest-phpunit"] = {
      root_ignore_files = { "tests/Pest.php" },
    },
  },
}
