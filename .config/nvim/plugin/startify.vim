"http://www.patorjk.com/software/taag/
let g:startify_custom_header = [
  \" ('-. .-.    ('-.                                                         _  .-')                ('-.        .-') _   _ .-') _   ",
  \"( OO )  /  _(  OO)                                                       ( \\( -O )             _(  OO)      ( OO ) ) ( (  OO) )  ",
  \",--. ,--. (,------.  ,--.       ,--.       .-'),-----.          ,------.  ,------.    ,-.-')  (,------. ,--./ ,--,'   \\     .'_  ",
  \"|  | |  |  |  .---'  |  |.-')   |  |.-')  ( OO'  .-.  '      ('-| _.---'  |   /`. '   |  |OO)  |  .---' |   \\ |  |\\   ,`'--..._) ",
  \"|   .|  |  |  |      |  | OO )  |  | OO ) /   |  | |  |      (OO|(_\\      |  /  | |   |  |  \\  |  |     |    \\|  | )  |  |  \\  ' ",
  \"|       | (|  '--.   |  |`-' |  |  |`-' | \\_) |  |\\|  |      /  |  '--.   |  |_.' |   |  |(_/ (|  '--.  |  .     |/   |  |   ' | ",
  \"|  .-.  |  |  .--'  (|  '---.' (|  '---.'   \\ |  | |  |      \\_)|  .--'   |  .  '.'  ,|  |_.'  |  .--'  |  |\\    |    |  |   / : ",
  \"|  | |  |  |  `---.  |      |   |      |     `'  '-'  '        \\|  |_)    |  |\\  \\  (_|  |     |  `---. |  | \\   |    |  '--'  / ",
  \"`--' `--'  `------'  `------'   `------'       `-----'          `--'      `--' '--'   `--'     `------' `--'  `--'    `-------'  ",
\]
      
let g:startify_session_dir = '~/.config/nvim/session'
let g:startify_session_persistence = 1
let g:startify_session_delete_buffers = 1

let g:startify_files_number = 15

let g:startify_lists = [
  \ { 'type': 'files',     'header': ['   MRU Files']                        },
  "\ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
  \ { 'type': 'sessions',  'header': ['   Sessions']                     },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']                    },
  \ ]

let g:startify_change_to_vcs_root = 1
let g:startify_session_persistence = 1

let g:startify_bookmarks = [
  \ { 'i': '~/Git/dotfiles/.config/nvim/init.vim' },
  \ { 'z': '~/Git/dotfiles/.config/.zshrc' },
  \ { 'r': '~/Git/dotfiles/.config/ranger/rc.conf' },
  \ ]

let g:startify_enable_special = 0
