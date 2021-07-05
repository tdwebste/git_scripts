

#python -m pip install gitpython

import csv
import re
import pprint
import git
import os
import subprocess
import argparse


class ArchRepo:
    def __init__(self, csv_name = 'Report.csv', ):
        self.csv_name = csv_name
        self.pat_arch = 'Delete but keep the history'
        self.pat_supr = 'Add Suppression files'
        #self.pat_supr_detect = '.*(Detected .* in (.*))*Number'
        self.pat_supr_detect = 'Detected .* in (.*)'
        self.repo_name = ''
        self.br_supr = {}
        self.br_arch = {}
        self.root_path = os.getcwd()



    def is_valid_regex(self, pattern: re.Pattern, escape: bool) -> bool:
        try:
            if escape: re.compile(re.escape(pattern, re.I))
            else: re.compile(pattern, re.I)
            is_valid = True
        except re.error:
            is_valid = False
        return is_valid

    def is_branch(self, branch) -> tuple:
        is_found = True
        #print(f'Repo Path: {self.repo_path} Type: {type(self.repo_path)}')
        os.chdir(self.repo_path)

        branchlist = subprocess.run(['git', 'branch', '-a'], capture_output = True)
        #print(f'branchlist Type: {type(branchlist.stdout.decode())}')
        #pprint.pprint(branchlist.stdout.decode())
        remote_branch_pat = f'(origin/{branch})$'
        if self.is_valid_regex(remote_branch_pat, escape=False):
            regex_remote_branch = re.compile(remote_branch_pat, re.M)
            match_remote_branch = regex_remote_branch.search(branchlist.stdout.decode())
            if not match_remote_branch is None:
                remote_branch = match_remote_branch.group(0)
                #print(f'{branch} Remove Branch: {remote_branch}')

                match_branch = re.search(r'[a-z]+/(.*)', remote_branch)
                branch = match_branch.group(1)
                #print(f'Local Branch: {branch}')

                if self.check_branch(branch):
                    is_found = True
                else:
                    is_found = False
            else:
                is_found = False
        else:
            print(f'\nINVALID branch Regex "{remote_branch_pat}"')
            is_found = False

        os.chdir(self.root_path)
        return (is_found, self.repo.active_branch)



    def check_branch(self, branch) -> bool:
        is_found = True
        #print(f'\n{self.repo_name}')
        #print(f'checkout {branch}')
        try:
            self.repo.git.checkout(branch, force=True)
            self.repo.git.pull()
        except Exception as e:
            print(e.args)
            is_found = False
        return is_found

    def branch_patch(self, start:str, repo_branch:git.refs.head.Head, repo_ref:git.refs.head.Head):
        os.chdir(self.repo_path)

        ref_br = repo_ref.name
        branch = repo_branch.name
        ref_commit = repo_ref.commit

        commit_range = f'{start}..{branch}'
        store_path = f'../arch/{self.repo_name}/{branch}'
        patchlist = subprocess.run(['git', 'format-patch', '--full-index', commit_range, '-o', store_path], capture_output = True)
        if patchlist.returncode != 0:
            print(patchlist.stderr, flush = True)
            print(patchlist)

        commit_diff = f'{ref_br}...{branch}'
        ref_br_name = ref_br.replace('/','_')
        branch_path_name = f'--output={store_path}/{ref_br_name}.merge-base-diff'
        branchdiff = subprocess.run(['git', 'diff', '--full-index', commit_diff, branch_path_name], capture_output = True)
        if branchdiff.returncode != 0:
            print(branchdiff.stderr, flush = True)
            print(branchdiff)

        finfo = open(f'../arch/{self.repo_name}/branch_info.txt', "a")
        finfo.write(f'patch list from merge-base at: {start} of      {branch} and {ref_br}\n')
        finfo.write(f'merge-base-diff            at: {start} between {branch} and {ref_br}\n')
        print(f'patch list from merge-base at: {start} of      {branch} and {ref_br}')
        print(f'merge-base-diff            at: {start} between {branch} and {ref_br}')

        os.chdir(self.root_path)

    def branch_diff(self, repo_branch:git.refs.head.Head, repo_ref:git.refs.head.Head):
        os.chdir(self.repo_path)

        ref_br = repo_ref.name
        branch = repo_branch.name
        ref_commit = repo_ref.commit

        commit_diff = f'{ref_br}..{branch}'
        ref_br_name = ref_br.replace('/','_')
        store_path = f'../arch/{self.repo_name}/{branch}'
        if not os.path.exists(store_path):
            os.makedirs(store_path)
        branch_path_name = f'--output={store_path}/{ref_br_name}.branch-diff'
        branchdiff = subprocess.run(['git', 'diff', '--full-index', commit_diff, branch_path_name], capture_output = True)
        if branchdiff.returncode != 0:
            print(branchdiff.stderr, flush = True)
            print(branchdiff)

        finfo = open(f'../arch/{self.repo_name}/branch_info.txt', "a")
        finfo.write(f'branch-diff                at: {ref_commit} between {branch} and {ref_br}\n')
        print(f'branch-diff                at: {ref_commit} between {branch} and {ref_br}')

        os.chdir(self.root_path)


    def branch_base(self, repo_branch:git.refs.head.Head, repo_ref:git.refs.head.Head) -> bool:

        is_found = True
        try:
            br_base = self.repo.git.merge_base(repo_branch.name, repo_ref.name)
        except Exception as e:
            #print(e.args)
            is_found = False
            #print(f'merge-base: FAILED of {repo_branch.name} and {repo_ref.name}', flush = True)
        else:
            self.branch_patch(br_base, repo_branch, repo_ref)
        finally:
            self.branch_diff(repo_branch, repo_ref)

        return is_found


    def dangling_branch(self, search = False):
        if search:
            for detach in self.br_arch[self.repo_pre]:
                for ref in self.br_supr[self.repo_pre]:
                    (success, ref) = self.is_branch(ref)
                    if success:
                        if self.branch_base(detach, ref):
                            self.br_arch[self.repo_pre].remove(detach)
                            break
        if len(self.br_arch[self.repo_pre]) != 0:
            #print(f'Suppresion branches {self.repo_pre}')
            #pprint.pprint(self.br_supr[self.repo_pre])
            print(f'detached branches {self.repo_pre}', flush = True)
            pprint.pprint(self.br_arch[self.repo_pre])




    def findall(self, max_count:int, archive:bool, suppress:bool):
        with open(self.csv_name) as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 0
            arch_count = 0
            supr_count = 0
            match_count = 0
            for row in csv_reader:
                line_count += 1
                if archive:
                    if arch_count > max_count:
                        quit()
                if suppress:
                    if supr_count > max_count:
                        quit()

                #elif line_count == 4:
                   # pprint.pprint(row)
                   # print(f'Column names are {", ".join(row)}')
                if line_count > 3:
                    self.repo_pre = self.repo_name
                    self.repo_name = row[2]
                    self.repo_remote = f'https://dev.azure.com/{row[0]}/{row[1]}/_git/{row[2]}'
                    ref_br = row[3]
                    action = f'{row[5]}'
                    match = re.search(r'refs/heads/(.*)', row[4])
                    if not self.repo_pre == self.repo_name:
                        self.init_repo()
                        if not self.get_repo():
                            continue
                        self.init_suppress()

                    if match:
                        branch = match.group(1)
                    else:
                        branch = "no match"
                        print(f'INVALID branch: {row[4]} in {self.csv_name}')

                    match_arch = self.regex_arch.findall(action)
                    match_supr = self.regex_supr.findall(action)
                    if match_supr:
                        supr_count += 1
                        self.br_supr[self.repo_name].append(branch)
                        if suppress:
                            print(f'\nSuppress:\t{self.repo_name}\t{branch}')
                            self.branch_suppress(branch)
                    elif match_arch:
                        arch_count += 1
                        if archive:
                            print(f'\nArchive:\t{self.repo_name}\t{branch}')
                            self.branch_arch(branch, ref_br)

            print(f'Processed {line_count}, Archived {arch_count}, Suppresed {supr_count} lines.')

    def init_repo(self):
        #print(f'Init repo branch list Prev: "{self.repo_pre}" Current: "{self.repo_name}"')
        if not self.repo_pre == '':
            self.dangling_branch(search = False)
        self.br_supr[self.repo_name] = []
        self.br_arch[self.repo_name] = []

    def get_repo(self) -> bool:
        is_found = True
        self.repo_path = f'{self.root_path}/{self.repo_name}'
        if not os.getcwd() == self.root_path:
            os.chdir(self.root_path)

        if os.path.isdir(self.repo_name):
            self.repo = git.Repo(self.repo_name)
        else:
            print(f'git clone {self.repo_remote, self.repo_name}', flush = True)
            try:
                self.repo = git.Repo.clone_from(self.repo_remote, self.repo_name)
            except Exception as e:
                print(f'\n')
                print(e.args)
                is_found = False
        return is_found


    def branch_arch(self, branch:str, ref_br:str):
        (success, repo_branch) =  self.is_branch(branch)
        if success:
            #print(f'active: {repo_branch.commit} {repo_branch.name}')
            (success, repo_ref_br) = self.is_branch(ref_br)
            #print(f'active: {repo_ref_br.commit} {repo_ref_br.name} TYPE: {type(repo_ref_br)}')
            if not self.branch_base(repo_branch, repo_ref_br):
                self.br_arch[self.repo_name].append(repo_branch.name)
        else:
            print(f'Branch NOT_FOUND: {branch}', flush = True)


    def init_suppress(self):
        os.chdir(self.repo_path)
        scan_init = subprocess.run(['powershell', 'c:\Tools\', 'init'], capture_output = True)
        if scan_init.returncode != 0:
            print(scan_init.stderr.decode(), flush = True)
            print(f'\n')
            print(scan_init)
        os.chdir(self.root_path)

    def branch_suppress(self, branch:str):
        (success, repo_branch) =  self.is_branch(branch)
        if success:
            os.chdir(self.repo_path)
            #print(f'save branch in csv {os.getcwd()}')
            scan = subprocess.run(['powershell', 'c:\Tools\', 'run', '-t', '' ], capture_output = True)
            if scan.returncode != 0:
                print(scan.stderr, flush = True)
            else:
                #match_supr_detect = self.regex_supr_detect.match(scan.stdout.decode())
                match_supr_detect = self.regex_supr_detect.findall(scan.stdout.decode())
                if not match_supr_detect is None:
                    #print(scan.stdout.decode())
                    #print(match_supr_detect.groups())
                    print(match_supr_detect, flush = True)
                else:
                    print(f'NO MATCH\n\n')
                    print(scan.stdout.decode(), flush = True)

        os.chdir(self.root_path)



    def archive(self, max_count:int, archive:bool, suppress:bool):
        if self.is_valid_regex(self.pat_arch, escape=False):
            self.regex_arch = re.compile(self.pat_arch, re.I)
        else:
            print(f'\nINVALID branch archive Regex "{self.pat_arch}"')

        if self.is_valid_regex(self.pat_supr, escape=False):
            self.regex_supr = re.compile(self.pat_supr, re.I)
        else:
            print(f'\nINVALID branch suppresion Regex "{self.pat_supr}"')

        if self.is_valid_regex(self.pat_supr_detect, escape=False):
            self.regex_supr_detect = re.compile(self.pat_supr_detect, re.I|re.M)
        else:
            print(f'\nINVALID branch suppresion Regex "{self.pat_supr_detect}"')
        #pprint.pprint(self.regex_supr_detect)

        self.findall(max_count, archive, suppress)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument('-f', action='store', dest='csv_name', type=str, default='Report.csv',
                    help='Report.csv file')

    parser.add_argument('-c', action='store', dest='count', type=int, default=1000,
                    help='Number of branches to process')

    parser.add_argument('-a', action='store_true', default=False,
                    dest='archive',
                    help='archieve branches Switch')

    parser.add_argument('-s', action='store_true', default=False,
                    dest='suppress',
                    help='supress branches Switch')


    parser.add_argument('--version', action='version', version='%(prog)s 1.0')

    args = parser.parse_args()
    pprint.pprint(args)

    archrepo = ArchRepo(args.csv_name)
    archrepo.archive(args.count - 1, args.archive, args.suppress)

