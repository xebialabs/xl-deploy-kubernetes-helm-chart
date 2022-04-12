package com.xebialabs.deployit.integration.test;

import java.io.*;
import java.nio.charset.Charset;
import java.util.*;
import java.util.regex.Pattern;
import javax.script.ScriptContext;
import javax.script.ScriptException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.testng.ITestContext;
import org.testng.annotations.AfterClass;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;
import com.google.common.io.Files;

import com.xebialabs.deployit.cli.Cli;
import com.xebialabs.deployit.cli.CliOptions;
import com.xebialabs.deployit.cli.Interpreter;
import com.xebialabs.deployit.util.PropertyUtil;

import static com.google.common.collect.Lists.newArrayList;


public class DeployitIntegrationTest {
    private static final Logger logger = LoggerFactory.getLogger(DeployitIntegrationTest.class);

    private static final String SETUP_FILE = "setUp.py";
    private static final String SETUP_SUITE_FILE = "setUpSuite.py";
    private static final String TEARDOWN_FILE = "tearDown.py";
    private static final String TEARDOWN_SUITE_FILE = "tearDownSuite.py";
    private static final String BASE_TEST_DIR = "src/test/jython";
    private static final File WORK_DIR = new File("work");
    private static final Set<String> FRAMEWORK_FILES = new HashSet<>() {{
        add(SETUP_FILE);
        add(SETUP_SUITE_FILE);
        add(TEARDOWN_FILE);
        add(TEARDOWN_SUITE_FILE);
    }};

    private static final File cliRuntime = Objects.requireNonNull(new File("build/integration-server")
            .listFiles(file -> file.getName().startsWith("xl-deploy-") && file.getName().endsWith("-cli")))[0];

    private static final String testsToRunRegExpPattern = System.getProperty("DeployitIntegrationTest.testsToRunRegExpPattern", ".*\\.py");
    private static final String repositoryDatabase = System.getProperty("DeployitIntegrationTest.repositoryDatabase", ".*\\.py");
    private static final Pattern testsToRunPattern = Pattern.compile(testsToRunRegExpPattern);

    private static abstract class Props {

        static Props createProps() {
            if (OperatorMetadataBasedProps.operatorMetadataProperties.exists()) {
                return new OperatorMetadataBasedProps();
            } else if (ClusterMetadataBasedProps.clusterMetadataProperties.exists()) {
                return new ClusterMetadataBasedProps();
            } else if (HelmMetadataBasedProps.helmMetadataProperties.exists()) {
                return new HelmMetadataBasedProps();
            } else {
                return new DeployitConfBasedProps();
            }
        }

        private final boolean tlsEnabled;
        private final boolean sslEnabled;

        protected Props(final boolean tlsEnabled, final boolean sslEnabled) {
            this.tlsEnabled = tlsEnabled;
            this.sslEnabled = sslEnabled;
        }

        protected boolean isTlsEnabled() {
            return tlsEnabled;
        }

        protected boolean isSslEnabled() {
            return sslEnabled;
        }

        protected void setupSsl() {
            if (sslEnabled && getServerRuntime() != null) {
                System.setProperty("javax.net.ssl.trustStore", getServerRuntime() + "/conf/myCliTruststore.jks");
                System.setProperty("javax.net.ssl.trustStorePassword", "st0r3p@ss");
            }
        }

        protected void setupTls() {
            if (tlsEnabled && getServerRuntime() != null) {
                System.setProperty("javax.net.ssl.trustStore", getServerRuntime() + "/conf/master_tls-truststore.pk12");
                System.setProperty("javax.net.ssl.trustStorePassword", "tmaster_");
            }
        }

        protected abstract File getServerRuntime();

        protected abstract int getIntegrationTestPort();

        protected abstract String getContextRoot();

        protected abstract String getHost();
    }

    private static class DeployitConfBasedProps extends Props {

        private static final File serverRuntime = Objects.requireNonNull(new File("build/integration-server")
                .listFiles(file -> file.getName().startsWith("xl-deploy-") && file.getName().endsWith("-server")))[0];
        private static final File deployitConf = new File(serverRuntime.getPath() + "/conf/deployit.conf");

        private DeployitConfBasedProps() {
            super(
                    Boolean.parseBoolean(PropertyUtil.readPropertiesFile(deployitConf).get("ssl").toString()),
                    Boolean.parseBoolean(System.getProperty("DeployitIntegrationTest.ssl",
                            String.valueOf(Boolean.parseBoolean(PropertyUtil.readPropertiesFile(deployitConf).get("ssl").toString()))))
            );
        }

        @Override
        protected File getServerRuntime() {
            return serverRuntime;
        }

        @Override
        protected int getIntegrationTestPort() {
            return Integer.parseInt(PropertyUtil.readPropertiesFile(deployitConf).getProperty("http.port"));
        }

        @Override
        protected String getContextRoot() {
            String contextRoot = PropertyUtil.readPropertiesFile(deployitConf).getProperty("http.context.root");
            return contextRoot.equals("/") ? "" : contextRoot;
        }

        @Override
        protected String getHost() {
            return "localhost";
        }
    }

    private static class ClusterMetadataBasedProps extends DeployitConfBasedProps {
        static final File clusterMetadataProperties = new File("build/integration-server/deploy/cluster/cluster-metadata.properties");

        @Override
        protected int getIntegrationTestPort() {
            return Integer.parseInt(PropertyUtil.readPropertiesFile(clusterMetadataProperties).getProperty("cluster.port"));
        }

        @Override
        protected String getContextRoot() {
            return "";
        }
    }

    private static class OperatorMetadataBasedProps extends Props {
        static final File operatorMetadataProperties = new File("build/integration-server/deploy/operator/operator-metadata.properties");

        OperatorMetadataBasedProps() {
            super(false, false);
        }

        @Override
        protected File getServerRuntime() {
            return null;
        }

        @Override
        protected int getIntegrationTestPort() {
            return Integer.parseInt(PropertyUtil.readPropertiesFile(operatorMetadataProperties).getProperty("cluster.port"));
        }

        @Override
        protected String getContextRoot() {
            return PropertyUtil.readPropertiesFile(operatorMetadataProperties).getProperty("cluster.context-root");
        }

        @Override
        protected String getHost() {
            return PropertyUtil.readPropertiesFile(operatorMetadataProperties).getProperty("cluster.fqdn");
        }
    }

    private static class HelmMetadataBasedProps extends Props {
        static final File helmMetadataProperties = new File("build/integration-server/deploy/helm/helm-metadata.properties");

        HelmMetadataBasedProps() {
            super(false, false);
        }

        @Override
        protected File getServerRuntime() {
            return null;
        }

        @Override
        protected int getIntegrationTestPort() {
            return Integer.parseInt(PropertyUtil.readPropertiesFile(helmMetadataProperties).getProperty("cluster.port"));
        }

        @Override
        protected String getContextRoot() {
            return PropertyUtil.readPropertiesFile(helmMetadataProperties).getProperty("cluster.context-root");
        }

        @Override
        protected String getHost() {
            return PropertyUtil.readPropertiesFile(helmMetadataProperties).getProperty("cluster.fqdn");
        }
    }


    private final Props props = Props.createProps();

    private Cli cli;
    private Boolean suiteSetupExecuted = false;

    File temporaryFolder;

    private Interpreter interpreter;
    private File scriptFile;
    private final String groupName;

    public DeployitIntegrationTest(String groupName) {
        this.groupName = groupName;
    }

    private String getBaseGroupDir() {
        return System.getProperty("jythonTestBaseDir", BASE_TEST_DIR + "/" + groupName);
    }

    /**
     * Returns a List<Object[]> which contains:
     * - the file to run
     * - whether to run or ignore the test.
     */
    @DataProvider(name = "jythonTests")
    public Iterator<Object[]> scriptsToRun(ITestContext context) {
        logger.info("Using pattern '{}' for test cases", testsToRunRegExpPattern);

        final String baseDir = getBaseGroupDir();
        logger.info("Running all tests in {}", baseDir);
        List<Object[]> targets = new ArrayList<>();
        File baseDirFile = new File(baseDir);
        FilenameFilter filter = getEnabledScriptsFilter();
        scriptDir(baseDirFile, filter, targets);
        return targets.iterator();
    }

    private void scriptDir(File testsDir, FilenameFilter filter, final List<Object[]> targets) {
        if (testsDir.exists()) {
            File[] scriptFiles = testsDir.listFiles(filter);
            assert scriptFiles != null;

            Arrays.sort(scriptFiles, Comparator.comparing(File::getPath));
            for (File eachFile : scriptFiles) {
                if (eachFile.isDirectory()) {
                    scriptDir(eachFile, filter, targets);
                } else {
                    addTarget(targets, eachFile);
                }
            }
        }
    }

    private FilenameFilter getEnabledScriptsFilter() {
        final List<String> enabledScripts = getEnabledScripts(new File(BASE_TEST_DIR));
        return (File dir, String name) -> {
            boolean isDirectory = new File(dir, name).isDirectory();
            boolean testFrameworkFile = FRAMEWORK_FILES.contains(name);
            boolean correctExtension = checkExtension(name, ".py") || checkExtension(name, ".cli");
            boolean isEnabled = enabledScripts.isEmpty() || enabledScripts.contains(name);
            return isDirectory || (correctExtension && isEnabled && !testFrameworkFile);
        };
    }

    private List<String> getEnabledScripts(File deployedItestDir) {
        File enabledItestsFile = new File(deployedItestDir, "enabled-itests");
        List<String> enabledItests = newArrayList();
        if (enabledItestsFile.exists()) {
            List<String> tests;
            try {
                tests = Files.readLines(enabledItestsFile, Charset.defaultCharset());
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
            enabledItests.addAll(tests);
        }
        return enabledItests;
    }

    private boolean checkExtension(String name, String suffix) {
        return name.endsWith(suffix) || name.endsWith(suffix + "ignore");
    }

    private void addTarget(final List<Object[]> targets, final File eachFile) {
        if (testsToRunPattern.matcher(eachFile.getName()).matches()) {
            logger.info("Adding testcase for {}", eachFile);
            targets.add(new Object[]{eachFile, !eachFile.getName().endsWith("ignore")});
        } else {
            logger.info("Ignoring testcase for {}", eachFile);
        }
    }

    // lazily init the cli preferred over BeforeClass to prevent startup slowdown
    private void lazyInitCli() throws Exception {
        props.setupSsl();
        props.setupTls();
        int integrationTestPort = props.getIntegrationTestPort();
        String contextRoot = props.getContextRoot();

        if (cli == null) {
            CliOptions options = new CliOptions();
            options.setHost(props.getHost());
            options.setContext(contextRoot);
            options.setPort(integrationTestPort);
            options.setSecured(props.isSslEnabled());
            options.setExposeProxies(true);
            options.setUsername("admin");
            options.setPassword("admin");
            options.setSocketTimeout(10000 * 20); // 20 times the default
            options.setExtensionFolderName(cliRuntime + "/ext");

            logger.info("Connecting with the next options: contextRoot=" + contextRoot +
                    ",integrationTestPort=" + integrationTestPort + ",sslEnabled=" + props.isSslEnabled());

            cli = new Cli(options);
        }
    }

    private void lazySetupTestGroup() throws ScriptException, FileNotFoundException {
        if (!suiteSetupExecuted) {
            logger.info("Trying to find and execute {} for group: {}", SETUP_SUITE_FILE, groupName);
            scanForFileInParentDirectoriesAndExecute(SETUP_SUITE_FILE, new File(getBaseGroupDir()));
            suiteSetupExecuted = true;
        }
    }

    private void cleanupTaskBackup() {
        if (WORK_DIR.exists()) {
            for (File file : getWorkDirFiles()) {
                if (file.getName().endsWith(".task") && !file.delete()) {
                    logger.warn("File {} is not deleted", file);
                }
            }
        }
    }

    @Test(dataProvider = "jythonTests")
    public void testCliScripts(File scriptFileToRun, Boolean t) throws Exception {
        lazyInitCli();

        this.scriptFile = scriptFileToRun;
        logger.info(">>>>>>>>>>>>>>>>>>start>>>>>>>>>>>>>>>>>>>>>>> {}", scriptFile.getName());

        logger.info("Executing {}", scriptFile.getName());

        temporaryFolder = java.nio.file.Files.createTempDirectory("itest").toFile();

        System.out.println("This is the temp folder." + temporaryFolder);

        interpreter = cli.getNewInterpreter();
        interpreter.getScriptContext().setAttribute("_context_root", props.getContextRoot(), ScriptContext.ENGINE_SCOPE);
        interpreter.getScriptContext().setAttribute("_global_integration_test_port", props.getIntegrationTestPort(), ScriptContext.ENGINE_SCOPE);
        interpreter.getScriptContext().setAttribute("_integration_server_runtime_directory", props.getServerRuntime(), ScriptContext.ENGINE_SCOPE);
        interpreter.getScriptContext().setAttribute("_repository_database", repositoryDatabase, ScriptContext.ENGINE_SCOPE);

        cleanupTaskBackup();

        lazySetupTestGroup();
        logger.info("Executing setup for {}", scriptFile.getName());
        scanForFileInParentDirectoriesAndExecute(SETUP_FILE, scriptFile.getParentFile());
        executeUtilScript("register-dsl.py");

        System.out.println(">> " + scriptFile.getPath());
        logger.info("Executing script for {}", scriptFile.getName());
        // Execute script
        TemporaryDirectoryHolder.init(temporaryFolder);
        try {
            interpreter.evaluateFile(scriptFile.getAbsolutePath());
        } catch (Exception e) {
            logger.error("Exception while executing script " + scriptFile, e);
            throw new Exception("Errors found during executing " + scriptFile.getName(), e);
        } finally {
            TemporaryDirectoryHolder.destroy();
        }
        logger.info("Executed script for {}", scriptFile.getName());
    }

    private void scanForFileInParentDirectoriesAndExecute(String fileNameToScanUpFor, File parentDir) throws ScriptException, FileNotFoundException {
        File fileToExecute = new File(parentDir, fileNameToScanUpFor);
        logger.info(parentDir + ": " + fileToExecute);
        final String lastPartOfBaseTestDir = BASE_TEST_DIR.substring(BASE_TEST_DIR.lastIndexOf('/') + 1);
        while (!fileToExecute.exists()) {
            if (parentDir.getAbsolutePath().endsWith(lastPartOfBaseTestDir)) {
                break;
            }
            parentDir = parentDir.getParentFile();
            fileToExecute = new File(parentDir, fileNameToScanUpFor);
            logger.info(parentDir + ": " + fileToExecute);
        }

        if (fileToExecute.exists()) {
            interpreter.evaluate(new FileReader(fileToExecute));
        }
    }

    @AfterClass
    public void tearDownTestGroup() throws ScriptException, FileNotFoundException {
        if (suiteSetupExecuted) {
            logger.info("Trying to find and execute {} for group: {}", TEARDOWN_SUITE_FILE, groupName);
            scanForFileInParentDirectoriesAndExecute(TEARDOWN_SUITE_FILE, new File(getBaseGroupDir()));
        }
    }

    @AfterMethod
    public void tearDown() throws ScriptException, IOException {
        logger.info("Executing teardown script for {}", scriptFile.getName());
        scanForFileInParentDirectoriesAndExecute(TEARDOWN_FILE, scriptFile.getParentFile());
        logger.info("Executed teardown script for {}", scriptFile.getName());
        temporaryFolder.delete();
        logger.info(">>>>>>>>>>>>>>>>>>end>>>>>>>>>>>>>>>>>>>>>>> {}", scriptFile.getName());
    }

    private File[] getWorkDirFiles() {
        File[] files = WORK_DIR.listFiles();
        if (files == null) {
            return new File[]{};
        }
        return files;
    }

    private void executeUtilScript(String scriptName) throws ScriptException, IOException {
        interpreter.evaluate(new InputStreamReader(new ClassPathResource(scriptName).getInputStream()));
    }
}
